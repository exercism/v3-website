module Mentor
  class ReplyToDiscussion
    include Mandate

    initialize_with :discussion, :iteration, :content_markdown

    def call
      discussion_post = Iteration::DiscussionPost.create!(
        iteration: iteration,
        source: discussion,
        content_markdown: content_markdown,
        user: discussion.mentor
      )

      Notification::Create.(
        solution.user,
        :mentor_replied_to_discussion,
        { discussion_post: discussion_post }
      )

      discussion_post
    end

    private
    memoize
    def solution
      iteration.solution
    end
  end
end
