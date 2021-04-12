require_relative "table_migration"

module V2ETL
  module TableMigrations
    class MigrateMentorDiscussions < TableMigration
      include Mandate

      def table_name
        "mentor_discussions"
      end

      def model
        Mentor::Discussion
      end

      def call
        # Add UUID
        add_non_nullable_column :uuid, :string do
          SecureRandom.compact_uuid
        end
        add_index :uuid, unique: true

        # Other adds
        add_column :requires_student_action_since, :datetime

        # Removes
        remove_column :show_feedback_to_mentor

        # Renames
        rename_column :user_id, :mentor_id
        rename_column :requires_action_since, :requires_mentor_action_since

        # Migrate abandoned to finished
        # TODO: Is there a state here we want too?
        add_column :finished_at, :datetime
        model.where(abandoned: true).update_all("finished_at = NOW()")
        remove_column :abandoned

        # TODO: Migrate rating to the new system

        # TODO: Migrate feedback to testimonials

        # TOOD: Decide about mentor_reminder_sent_at

        # Create request_id
        # TODO: Do we want to create mentor_requests for existing discussions?
        add_column :request_id, :bigint, null: true
        add_foreign_key :mentor_requests, column: :request_id
      end
    end
  end
end
