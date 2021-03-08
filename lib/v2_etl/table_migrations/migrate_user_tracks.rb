require_relative "table_migration"

module V2ETL
  module TableMigrations
    class MigrateUserTracks < TableMigration
      include Mandate

      def table_name
        "user_tracks"
      end

      def model
        UserTrack
      end

      def call
        # These were never used
        remove_column :handle
        remove_column :avatar_url
        remove_column :independent_mode

        # TODO: Add paused_at?

        # TODO: Check this is honoured before putting ETL on .lol
        rename_column :anonymous, :anonymous_during_mentoring
      end
    end
  end
end
