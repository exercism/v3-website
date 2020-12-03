module Git
  class SyncConcept < Sync
    include Mandate

    def initialize(concept)
      super(concept.track, concept.synced_to_git_sha)

      @concept = concept
    end

    def call
      return concept.update!(synced_to_git_sha: head_git_concept.commit.oid) unless concept_needs_updating?

      concept.update!(
        slug: config_concept[:slug],
        name: config_concept[:name],
        blurb: config_concept[:blurb],
        synced_to_git_sha: head_git_concept.commit.oid
      )
    end

    private
    attr_reader :concept

    def concept_needs_updating?
      return false if synced_to_head?
      return false unless track_config_modified?

      config_concept[:slug] != concept.slug ||
        config_concept[:name] != concept.name ||
        config_concept[:blurb] != concept.blurb
    end

    memoize
    def config_concept
      # TODO: determine what to do when the concept could not be found
      config_concepts.find { |e| e[:uuid] == concept.uuid }
    end

    memoize
    def head_git_concept
      Git::Concept.new(concept.track.slug, concept.slug, git_repo.head_sha, repo: git_repo)
    end
  end
end
