module ComponentsHelper
  def example_iterations_summary_table(solution)
    react_component("example-iterations-summary-table", {
                      solution_id: solution.id,
                      iterations: solution.serialized_iterations
                    })
  end

  def maintaining_iterations_summary_table(iterations)
    react_component("maintaining-iterations-summary-table", {
                      iterations: iterations.map(&:serialized)
                    })
  end

  def notification_icon(user)
    react_component("notification-icon", { count: user.notifications.unread.count })
  end

  def mentor_inbox(conversations_request, tracks_request, sort_options)
    react_component("mentor-inbox", {
                      conversations_request: conversations_request,
                      tracks_request: tracks_request,
                      sort_options: sort_options
                    })
  end

  def mentor_solutions_list(request, sort_options)
    react_component("mentor-solutions-list", { request: request, sort_options: sort_options })
  end

  def track_list(tracks, request)
    options = (request[:options] || {}).merge(initialData: tracks)

    react_component("track-list", { request: request.merge(options: options) })
  end

  private
  def react_component(id, data)
    tag :div, {
      "data-react-#{id}": true,
      "data-react-data": data.to_json
    }
  end
end
