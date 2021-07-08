module Git
  class SyncMainDocs
    include Mandate

    def call
      repo.fetch!

      sync_config! :using
      sync_config! :building
      sync_config! :mentoring
      sync_config! :community
    end

    private
    def sync_config!(section)
      config = repo.read_json_blob(repo.head_commit, "#{section}/config.json")

      config.to_a.each do |doc_config|
        Git::SyncDoc.(doc_config, section)
      end
    end

    memoize
    def repo
      # TODO: (Optional): Put a constant somewhere for this (also used in sync_doc)
      Git::Repository.new(repo_url: "https://github.com/exercism/docs")
    end
  end
end
