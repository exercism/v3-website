module V2ETL
  module DataProcessors
    class ProcessMentorStudentRelationships
      include Mandate

      def call
        # TODO: This currently doesn't cope if there are more than one
        # set of mentor discussions for the same solution.
        #
        # The solution I want to take is to copy all the posts to
        # each discussion. It's not ideal but it's the only sane way.
        #
        # So the following steps need to be taken:
        # 1. Remove any mentor discussions where there are no
        #    posts by that mentor (ie where they joined then left)
        # 2. Add an idx flag to discussions, and populate with an
        #    incrementing number for each discussion on the same solution.
        # 3. For each idx in the db (1..n), do the pass below but have
        #    the idx as a join condition.
        # x. Remove the idx flag from discussions

        # Create a v3 mentor_discussion_post
        # for each v2 discussion_post
        ActiveRecord::Base.connection.execute(<<-SQL)
        INSERT INTO mentor_student_relationships (
          mentor_id,
          student_id,
          num_discussions,
          created_at, updated_at
        )
        SELECT
          mentor_id, solutions.user_id, COUNT(*),
          NOW(), NOW()
        FROM mentor_discussions
        INNER JOIN solutions on solutions.id = mentor_discussions.solution_id
        GROUP BY mentor_id, solutions.user_id
        SQL
      end
    end
  end
end
