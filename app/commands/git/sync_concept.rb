module Git
  class SyncConcept < Sync
    include Mandate

    def initialize(concept)
      super(concept.track, concept.synced_to_git_sha)

      @concept = concept
    end

    def call
      return concept.update_columns(synced_to_git_sha: head_git_concept.synced_git_sha) unless concept_needs_updating?

      concept.update!(
        slug: concept_config[:slug],
        name: concept_config[:name],
        blurb: head_git_concept.blurb,
        synced_to_git_sha: head_git_concept.synced_git_sha
      )
    end

    private
    attr_reader :concept

    def concept_needs_updating?
      return false unless track_config_modified?

      concept_config[:slug] != concept.slug ||
        concept_config[:name] != concept.name ||
        head_git_concept.blurb != concept.blurb
    end

    memoize
    def concept_config
      # TODO: determine what to do when the concept could not be found
      head_git_track.find_concept(concept.uuid)
    end

    memoize
    def head_git_concept
      Git::Concept.new(concept_config[:slug], git_repo.head_sha, repo: git_repo)
    end
  end
end
