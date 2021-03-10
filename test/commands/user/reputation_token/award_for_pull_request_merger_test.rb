require "test_helper"

class User::ReputationToken::AwardForPullRequestMergerTest < ActiveSupport::TestCase
  test "adds reputation token to pull request merger when action is closed and merged" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = true
    merged_by = "merger22"
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []
    user = create :user, handle: "Merger-22", github_username: "merger22"

    User::ReputationToken::AwardForPullRequestMerger.(action, login,
      url: url, html_url: html_url, labels: labels, repo: repo, pr_id: pr_id, pr_number: pr_number, merged: merged, merged_by: merged_by) # rubocop:disable Layout/LineLength

    assert User::ReputationTokens::CodeMergeToken.where(user: user).exists?
  end

  test "reputation is awarded once per merger per pull request" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = true
    merged_by = "merger22"
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []
    user = create :user, handle: "Merger-22", github_username: "merger22"
    create :user_code_merge_reputation_token,
      user: user,
      level: :regular,
      params: {
        repo: repo,
        pr_id: pr_id
      }

    User::ReputationToken::AwardForPullRequestMerger.(action, login,
      url: url, html_url: html_url, labels: labels, repo: repo, pr_id: pr_id, pr_number: pr_number, merged: merged, merged_by: merged_by) # rubocop:disable Layout/LineLength

    assert_equal 1, User::ReputationTokens::CodeMergeToken.where(user: user).size
  end

  test "reputation not awarded to pull request merger if merger is not known" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = true
    merged_by = "merger22"
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []

    User::ReputationToken::AwardForPullRequestMerger.(action, login,
      url: url, html_url: html_url, labels: labels, repo: repo, pr_id: pr_id, pr_number: pr_number, merged: merged, merged_by: merged_by) # rubocop:disable Layout/LineLength

    refute User::ReputationTokens::CodeMergeToken.exists?
  end

  test "reputation not awarded to pull request merger if pull request is closed but not merged" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = false
    merged_by = nil
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []
    user = create :user, handle: "Merger-22", github_username: "merger22"

    User::ReputationToken::AwardForPullRequestMerger.(action, login,
      url: url, html_url: html_url, labels: labels, repo: repo, pr_id: pr_id, pr_number: pr_number, merged: merged, merged_by: merged_by) # rubocop:disable Layout/LineLength

    refute User::ReputationTokens::CodeMergeToken.where(user: user).exists?
  end

  test "reputation not awarded to pull request merger if pull request merger is also the author" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = false
    merged_by = nil
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []
    user = create :user, handle: "User-22", github_username: "user22"

    User::ReputationToken::AwardForPullRequestMerger.(action, login,
      url: url, html_url: html_url, labels: labels, repo: repo, pr_id: pr_id, pr_number: pr_number, merged: merged, merged_by: merged_by) # rubocop:disable Layout/LineLength

    refute User::ReputationTokens::CodeMergeToken.where(user: user).exists?
  end

  test "pull request adds reputation token with default value" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = true
    merged_by = "merger22"
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []
    user = create :user, handle: "Merger-22", github_username: "merger22"

    User::ReputationToken::AwardForPullRequestMerger.(action, login,
      url: url, html_url: html_url, labels: labels, repo: repo, pr_id: pr_id, pr_number: pr_number, merged: merged, merged_by: merged_by) # rubocop:disable Layout/LineLength

    assert_equal 2, user.reputation_tokens.last.value
  end
end
