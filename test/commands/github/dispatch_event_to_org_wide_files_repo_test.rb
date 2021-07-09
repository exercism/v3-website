require "test_helper"

class Github::DispatchEventToOrgWideFilesRepoTest < ActiveJob::TestCase
  test "dispatch repository event for single repo" do
    stub_request(:post, "https://api.github.com/repos/exercism/org-wide-files/dispatches").
      with(body: '{"event_type":"appends_update","client_payload":{"repos":["exercism/ruby"]}}')

    Github::DispatchEventToOrgWideFilesRepo.(:appends_update, ["exercism/ruby"])

    assert_requested(:post, "https://api.github.com/repos/exercism/org-wide-files/dispatches", times: 1) do |req|
      req.body == '{"event_type":"appends_update","client_payload":{"repos":["exercism/ruby"]}}'
    end
  end

  test "dispatch repository event for multiples repos" do
    stub_request(:post, "https://api.github.com/repos/exercism/org-wide-files/dispatches").
      with(body: '{"event_type":"appends_update","client_payload":{"repos":["exercism/website","exercism/configlet"]}}')

    Github::DispatchEventToOrgWideFilesRepo.(:appends_update, ["exercism/website", "exercism/configlet"])

    assert_requested(:post, "https://api.github.com/repos/exercism/org-wide-files/dispatches", times: 1) do |req|
      req.body == '{"event_type":"appends_update","client_payload":{"repos":["exercism/website","exercism/configlet"]}}'
    end
  end

  test "raises for unknown event type" do
    assert_raises do
      Github::DispatchEventToOrgWideFilesRepo.(:unknown, ["exercism/website"])
    end
  end
end
