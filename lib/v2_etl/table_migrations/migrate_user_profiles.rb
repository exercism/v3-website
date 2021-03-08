require_relative "table_migration"

module V2ETL
  module TableMigrations
    class MigrateUserProfiles < TableMigration
      include Mandate

      def table_name
        "user_profiles"
      end

      def model
        UserProfile
      end

      def call
        # TODO: What do we want to do with this field?
        # Should this be in profile or part of a user?
        change_column_null :display_name, true
      end
    end
  end
end
