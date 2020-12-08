require_relative './base_test_case'

class Webhooks::RepoUpdatesControllerTest < Webhooks::BaseTestCase
  test "create should return 403 when signature is invalid" do
    payload = {
      ref: 'refs/heads/master',
      repository: { name: 'csharp' }
    }

    invalid_headers = headers(payload)
    invalid_headers['HTTP_X_HUB_SIGNATURE_256'] = "invalid_signature"

    post webhooks_repo_updates_path, headers: invalid_headers, as: :json, params: payload
    assert_response 403
  end

  test "create should return 200 when signature is valid" do
    payload = {
      ref: 'refs/heads/master',
      repository: { name: 'csharp' }
    }

    post webhooks_repo_updates_path, headers: headers(payload), as: :json, params: payload
    assert_response 200
  end

  test "create should process repo update when signature is valid" do
    payload = {
      ref: 'refs/heads/master',
      repository: { name: 'csharp' }
    }
    Webhooks::ProcessRepoUpdate.expects(:call).with('refs/heads/master', 'csharp')

    post webhooks_repo_updates_path, headers: headers(payload), as: :json, params: payload
  end

  test "create should return 200 when ping event is sent" do
    payload = {
      ref: 'refs/heads/master',
      repository: { name: 'csharp' }
    }

    post webhooks_repo_updates_path, headers: headers(payload, event: 'ping'), as: :json, params: payload
    assert_response 200
  end
end
