class Mentor::RequestComment
  include ActiveModel::Model

  attr_accessor(
    :uuid,
    :author,
    :by_student,
    :content_markdown,
    :content_html,
    :iteration_idx,
    :updated_at,
    :discussion,
    :request
  )

  def self.from(request)
    return nil unless request
    return nil if request.comment_html.blank?

    discussion = request.discussion

    if discussion.posts.any?
      iteration_idx = discussion.posts.first.iteration_idx
    else
      iteration_idx = discussion.iterations.last.idx
    end

    new(
      uuid: "request-comment",
      iteration_idx: iteration_idx,
      author: request.student,
      by_student: true,
      content_markdown: request.comment_markdown,
      content_html: request.comment_html,
      updated_at: request.updated_at,
      request: request
    )
  end

  def by_student?
    by_student
  end

  def links
    {
      edit: Exercism::Routes.api_solution_mentor_request_url(request.solution.uuid, request)
    }
  end
end
