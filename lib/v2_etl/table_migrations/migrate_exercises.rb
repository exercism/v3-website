require_relative "table_migration"

module V2ETL
  module TableMigrations
    class MigrateExercises < TableMigration
      include Mandate

      def table_name
        "exercises"
      end

      def model
        Exercise
      end

      def call
        remove_column :dark_icon_url
        remove_column :turquoise_icon_url
        remove_column :white_icon_url

        # These are redundant
        remove_column :core
        remove_column :auto_approve
        remove_column :length
        remove_column :unlocked_by_id
        remove_column :description

        # TODO: When we support WIP etc this will probably change
        # Rename the column and reverse the values
        rename_column :active, :deprecated
        Exercise.update_all("deprecated = !deprecated")

        # These should all get set by the syncer
        add_non_nullable_column :type, :string, "'PracticeExercise'"
        add_non_nullable_column :git_sha, :string, "''"
        add_non_nullable_column :synced_to_git_sha, :string, "''"

        # TODO: Run this at the end of the fix script for this
        # Then switch these out
        # add_index :uuid, unique: true
        add_index %i[track_id uuid], unique: true
      end
    end
  end
end
