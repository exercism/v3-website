class Iteration
  class Create
    include Mandate

    def initialize(solution, files, submitted_via, major)
      @iteration_uuid = SecureRandom.compact_uuid

      @solution = solution
      @files = files
      @submitted_via = submitted_via
      @major = major

      # TODO: - Move this into another service
      # and that service should also guard filenames
      @files.each do |f|
        f[:digest] = Digest::SHA1.hexdigest(f[:content])
      end
    end

    def call
      # This needs to be fast.
      guard!

      # Kick off the threads to get things uploaded
      # before we do anything with the database.

      # These thread must *not* touch the DB or have any
      # db models passed to them.
      services_thread = Thread.new { init_services }

      create_iteration!
      create_files!
      update_solution!
      schedule_jobs!
      iteration.broadcast!

      # Finally wait for everyhting to finish before
      # we return the iteration
      services_thread.join

      # End by returning the new iteration
      iteration
    end

    private
    attr_reader :solution, :files, :iteration_uuid, :submitted_via, :major
    attr_reader :iteration

    def guard!
      last_iteration = solution.iterations.last
      return unless last_iteration

      prev_files = last_iteration.files.map { |f| "#{f.filename}|#{f.digest}" }
      new_files = files.map { |f| "#{f[:filename]}|#{f[:digest]}" }
      raise DuplicateIterationError if prev_files.sort == new_files.sort
    end

    def init_services
      git_slug = solution.git_slug
      git_sha = solution.git_sha
      track_repo = solution.track.repo

      # Let's get it up first, then we'll fan out to
      # all the services we want to run this,
      s3_uri = Iteration::UploadWithExercise.(iteration_uuid, git_slug, git_sha, track_repo, files)

      jobs = []
      jobs << [
        Thread.new do
          Iteration::TestRun::Init.(iteration_uuid, solution.track.slug, solution.exercise.slug, s3_uri)
        end
      ]
      if major
        jobs += [
          Thread.new do
            Iteration::Analysis::Init.(iteration_uuid, solution.track.slug, solution.exercise.slug, s3_uri)
          end,
          Thread.new do
            Iteration::Representation::Init.(iteration_uuid, solution.track.slug, solution.exercise.slug, s3_uri)
          end
        ]
      end

      jobs.each(&:join)
    end

    def create_iteration!
      attrs = {
        uuid: iteration_uuid,
        submitted_via: submitted_via,
        major: major
      }

      # If we've not run the analysers or representer
      # then set the attributes to cancelled
      unless major
        attrs[:analysis_status] = :cancelled
        attrs[:representation_status] = :cancelled
      end

      @iteration = solution.iterations.create!(attrs)
    end

    def create_files!
      files.map do |file|
        ActiveRecord::Base.connection_pool.with_connection do
          iteration.files.create!(
            file.slice(:uuid, :filename, :digest, :content)
          )
        end
      end.join
    end

    def update_solution!
      solution.status = :submitted if solution.pending?
      solution.save!
    end

    def schedule_jobs!
      AwardBadgeJob.perform_later(solution.user, :rookie)
    end
  end
end
