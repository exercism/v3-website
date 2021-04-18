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
        Mentor::Discussion.where.not(feedback: nil).
          where.not(feedback: "").
          includes(:solution).find_each do |discussion|
          Mentor::Testimonial.create!(
            mentor_id: discussion.user_id,
            discussion: discussion,
            student_id: discussion.solution.user_id,
            content: "feedback",
            revealed: true,
            created_at: discussion.updated_at,
            updated_at: discussion.updated_at
          )
        end
        remove_column :feedback

        # TOOD: Decide about mentor_reminder_sent_at

        # Create request_id
        add_column :request_id, :bigint, null: true
        add_foreign_key :mentor_requests, column: :request_id
      end
    end
  end
end
