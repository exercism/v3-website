require_relative "../react_component_test_case"

class MentoringInboxTest < ReactComponentTestCase
  test "mentoring inbox rendered correctly" do
    conversations_request = { endpoint: "conversations-endpoint" }
    tracks_request = { endpoint: "tracks-endpoint" }

    component = ReactComponents::Mentoring::Inbox.new(
      conversations_request, tracks_request
    )

    assert_component component,
      "mentoring-inbox",
      {
        conversations_request: { endpoint: "conversations-endpoint" },
        tracks_request: { endpoint: "tracks-endpoint" },
        sort_options: [
          { value: 'recent', label: 'Sort by Most Recent' },
          { value: 'exercise', label: 'Sort by Exercise' },
          { value: 'student', label: 'Sort by Student' }
        ]
      }
  end
end
