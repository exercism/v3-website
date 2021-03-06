require_relative "table_migration"

module V2ETL
  module TableMigrations
    class MigrateTracks < TableMigration
      include Mandate

      def table_name
        "tracks"
      end

      def model
        Track
      end

      def call
        # TODO: Do we want this. What are we doing instead?
        # TODO: Are there actually 2 of these in production?
        remove_column :syntax_highligher_language
        remove_column :syntax_highlighter_language

        # TODO: These need replacing with some icons
        remove_column :bordered_green_icon_url
        remove_column :bordered_turquoise_icon_url
        remove_column :hex_green_icon_url
        remove_column :hex_turquoise_icon_url
        remove_column :hex_white_icon_url

        # We read these from the git instead
        remove_column :code_sample
        remove_column :introduction

        # These should all get set by the syncer
        add_non_nullable_column :blurb, :string, "''", limit: 400
        add_non_nullable_column :synced_to_git_sha, :string, "''"
        add_column :tags, :json

        add_index :slug, unique: true
      end
    end
  end
end
