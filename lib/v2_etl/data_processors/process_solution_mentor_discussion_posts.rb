require_relative "table_migration"

module V2ETL
  module DataProcessors
    class ProcessSolutionMentorDiscussionPosts
      include Mandate

      def call
        # Migrate from the old table to the new
        # ActiveRecord::Base.connection.execute(<<-SQL)
        # INSERT INTO solution_mentor_discussion_posts (
        #   uuid,
        #   iteration_id,
        #   discussion_id,
        #   user_id,
        #   content_markdown, content_html,
        #   seen_by_student, seen_by_mentor,
        #   created_at, updated_at
        # )
        # SELECT
        #   UUID(),
        #   v2_discussion_posts.iteration_id,
        #   discussions.id, <<< HOW DO WE GET THIS??
        #   v2_discussion_posts.user_id
        #   0, 0, 0, 'cli',
        #   TRUE, TRUE
        #   '', '', NOW(), NOW()
        # FROM v2_discussion_posts
        # SQL
      end
    end
  end
end
