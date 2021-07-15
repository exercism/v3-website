module Mentor
  class StudentRelationship
    class ToggleFavorited
      include Mandate

      initialize_with :mentor, :student, :favorited

      def call
        return unless Mentor::Discussion.between(mentor: mentor, student: student).exists?

        relationship = Mentor::StudentRelationship.create_or_find_by!(
          mentor: mentor,
          student: student
        )
        relationship.update_column(:favorited, favorited)
      end
    end
  end
end
