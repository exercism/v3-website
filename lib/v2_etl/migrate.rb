# Run in a rails console with:
# require 'v2_etl/migrate'; V2ETL::Migrate.()

module V2ETL
  class Migrate
    include Mandate

    def call
      return if Rails.env.production?

      # The calls to reload in this method fix issues
      # with ActiveRecord caching the state of db tables.
      pre_create_tables!
      reload!

      create_tables!
      reload!

      migrate_tables!
      reload!

      post_migrate_tables!
      reload!

      migrate_data!

      # Final reload for anything that might come after, such as tests
      reload!
    end

    def pre_create_tables!
      # Move submissions sideways. These tables are too
      # different to migrate so need data moving between them
      # rather than just having columns changed.
      rename_table :submissions, :v2_submissions
      rename_table :submission_test_runs, :v2_submission_test_runs
      rename_table :notifications, :v2_notifications

      # Remove duplicate foreign key on sideways table
      execute("ALTER TABLE v2_submission_test_runs DROP FOREIGN KEY fk_rails_477e62a0ba")

      # Rename tables
      rename_table :solution_mentorships, :solution_mentor_discussions
    end

    def create_tables!
      # Create any new tables first
      # This ensures foreign keys will be present
      create_track_concepts
      create_user_track_learnt_concepts
      create_exercise_prerequisites
      create_exercise_taught_concepts
      create_submissions
      create_submission_test_runs
      create_submission_analyses

      create_exercise_representations
      create_submission_representations

      create_solution_mentor_requests

      create_badges
      create_bug_reports
      create_exercise_authorships
      create_exercise_contributorships
      create_mentor_student_relationships
      create_scratchpad_pages
      create_user_acquired_badges
      create_user_notifications
      create_user_activities
      create_user_auth_tokens
      create_user_reputation_tokens
    end

    # Make any structural changes to the tables
    def migrate_tables!
      migrate_solution_mentor_discussions

      migrate_discussion_posts_to_solution_mentor_discussion_posts

      migrate_exercises
      migrate_friendly_id_slugs
      migrate_iterations
      migrate_solutions
      migrate_tracks
      migrate_iteration_files_to_submission_files
      migrate_user_profiles
      migrate_user_track_mentorships
      migrate_user_tracks
      migrate_users
    end

    def post_migrate_tables!
      # Some tables need creating after the migrations have occurred
      # in order for foreign keys to be there.

      # TODO: Re-enable
      create_mentor_testimonials
    end

    def migrate_data!
      # Now do lots of data migrations
      # Each of these should have a class associated with
      # it and an equivlent test class

      # TODO: Populate users.github_usernames via GH API

      # TODO: Migrate users.is_mentor to users.became_mentor_at
      # based on the first solution_mentorship
    end

    def method_missing(meth) # rubocop:disable Style/MissingRespondToMissing
      if meth.starts_with?("create_")
        handle_create(meth)
      elsif meth.starts_with?("migrate_")
        handle_migrate(meth)
      else
        super(meth)
      end
    end

    def handle_create(meth)
      file = Dir[Rails.root.join("db/migrate/*_#{meth}.rb")].first
      require file

      meth.to_s.camelize.constantize.new.change
      # rescue ActiveRecord::StatementInvalid
      # TODO: Remove this
      # Failed
    end

    def handle_migrate(meth)
      file = Dir[Rails.root.join("lib/v2_etl/table_migrations/#{meth}.rb")].first
      require file

      "v2_e_t_l/table_migrations/#{meth}".camelize.constantize.()
    end

    def migrate_friendly_id_slugs
      # Noop
    end

    def migrate_discussion_posts_to_solution_mentor_discussion_posts
      # TODO: Rename table from discussion_posts to solution_mentor_discussion_posts
    end

    def migrate_solutions; end

    def migrate_iteration_files_to_submission_files; end

    def migrate_user_profiles; end

    def migrate_user_track_mentorships; end

    def migrate_user_tracks; end

    private
    delegate :rename_table, :execute, to: :connection
    def connection
      ActiveRecord::Base.connection
    end

    def reload!
      # Reload everything
      ActiveRecord::Base.descendants.each(&:reset_column_information)
    end
  end
end
