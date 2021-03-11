require "test_helper"

class User::ReputationToken::AwardForPullRequestTest < ActiveSupport::TestCase
  test "award reputation to pull request author" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_node_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = true
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []
    user = create :user, handle: "User-22", github_username: "user22"

    User::ReputationToken::AwardForPullRequest.(
      action: action, author: login, url: url, html_url: html_url,
      labels: labels, repo: repo, pr_node_id: pr_node_id, pr_number: pr_number, merged: merged
    )

    assert User::ReputationTokens::CodeContributionToken.where(user: user).exists?
  end

  test "award reputation to pull request reviewers" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_node_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = false
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []
    reviewer_1 = create :user, handle: "Reviewer-71", github_username: "reviewer71"
    reviewer_2 = create :user, handle: "Reviewer-13", github_username: "reviewer13"
    reviews = [
      { reviewer: reviewer_1.github_username },
      { reviewer: reviewer_2.github_username }
    ]

    User::ReputationToken::AwardForPullRequest.(
      action: action, author: login, url: url, html_url: html_url, labels: labels,
      repo: repo, pr_node_id: pr_node_id, pr_number: pr_number, merged: merged, reviews: reviews
    )

    assert User::ReputationTokens::CodeReviewToken.where(user: reviewer_1).exists?
    assert User::ReputationTokens::CodeReviewToken.where(user: reviewer_2).exists?
  end

  test "don't award reputation for pull request reviewers if there were no reviewers" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_node_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = false
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []
    reviews = []

    User::ReputationToken::AwardForPullRequest.(
      action: action, author: login, url: url, html_url: html_url, labels: labels,
      repo: repo, pr_node_id: pr_node_id, pr_number: pr_number, merged: merged, reviews: reviews
    )

    refute User::ReputationTokens::CodeReviewToken.exists?
  end

  test "award reputation to pull request merger" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_node_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = true
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []
    merger = create :user, handle: "Merged-88", github_username: "merger88"

    User::ReputationToken::AwardForPullRequest.(
      action: action, author: login, url: url, html_url: html_url, labels: labels,
      repo: repo, pr_node_id: pr_node_id, pr_number: pr_number, merged: merged, merged_by: merger.github_username
    )

    assert User::ReputationTokens::CodeMergeToken.where(user: merger).exists?
  end

  test "don't award reputation for pull request merged if the pull request was not merged" do
    action = 'closed'
    login = 'user22'
    repo = 'exercism/v3'
    pr_node_id = 'MDExOlB1bGxSZXF1ZXN0NTgzMTI1NTaQ'
    pr_number = 1347
    merged = false
    url = 'https://api.github.com/repos/exercism/v3/pulls/1347'
    html_url = 'https://github.com/exercism/v3/pull/1347'
    labels = []

    User::ReputationToken::AwardForPullRequest.(
      action: action, author: login, url: url, html_url: html_url,
      labels: labels, repo: repo, pr_node_id: pr_node_id, pr_number: pr_number, merged: merged
    )

    refute User::ReputationTokens::CodeMergeToken.exists?
  end
end
