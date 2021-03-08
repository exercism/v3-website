require_relative "table_migration"

module V2ETL
  module TableMigrations
    class MigrateUserTrackMentorships < TableMigration
      include Mandate

      def table_name
        "user_track_mentorships"
      end

      def model
        UserTrackMentorship
      end

      def call
        # These were never used
        remove_column :handle
        remove_column :avatar_url

        # We'll read these now from a profile if someone has one.
        remove_column :link_text
        remove_column :link_url

        # TODO: Do we leave bio here or move it somewhere else?
      end
    end
  end
end
