module V2ETL
  module TableMigrations
    class MigrateExercises
      include Mandate

      def call
        # TOOD: Remove unlocked_by_id
        # TOOD: Remove t.string "dark_icon_url"
        # TOOD: Remove t.string "turquoise_icon_url"
        # TOOD: Remove t.string "white_icon_url"
        # TOOD: Remove core
        # TOOD: Migrate active to deprecated
        # TOOD: Remove auto_approve
        # TODO: Remove description
        # TOOO: Remove length

        # TODO: Add type
        # TODO: Add git_sha
        # TODO: Add synced_to_git_sha
        # TODO: Add unique index on uuid
      end
    end
  end
end
