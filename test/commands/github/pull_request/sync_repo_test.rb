require "test_helper"

class Github::PullRequest::SyncRepoTest < ActiveSupport::TestCase
  test "imports all pull requests" do
    first_response = {
      data: {
        repository: {
          nameWithOwner: 'exercism/ruby',
          pullRequests: {
            nodes: [
              {
                url: 'https://github.com/exercism/ruby/pull/19',
                id: 'MDExOlB1bGxSZXF1ZXN0NTY4NDMxMTE4',
                createdAt: '2021-02-05T15:29:25Z',
                labels: {
                  nodes: []
                },
                merged: true,
                number: 19,
                state: 'MERGED',
                author: {
                  login: 'ErikSchierboom'
                },
                mergedBy: {
                  login: 'iHiD'
                },
                reviews: {
                  nodes: [
                    {
                      id: 'MDE3OlB1bGxSZXF1ZXN0UmV2aWV3NTg5NDY1MzEx',
                      author: {
                        login: 'iHiD'
                      }
                    }
                  ]
                }
              },
              {
                url: 'https://github.com/exercism/ruby/pull/8',
                id: 'MDExOlB1bGxSZXF1ZXN0NTYzOTgwNTkw',
                createdAt: '2021-01-29T13:20:35Z',
                labels: {
                  nodes: []
                },
                merged: true,
                number: 8,
                state: 'MERGED',
                author: {
                  login: 'ErikSchierboom'
                },
                mergedBy: {
                  login: 'iHiD'
                },
                reviews: {
                  nodes: [
                    {
                      id: 'MDE3OlB1bGxSZXF1ZXN0UmV2aWV3NTg0MzAyODk0',
                      author: {
                        login: 'ErikSchierboom'
                      }
                    }
                  ]
                }
              }
            ],
            pageInfo: {
              hasNextPage: true,
              endCursor: 'Y3Vyc29yOnYyOpK5MjAxOS0wMS0yMVQxNDo0OTo0MCswMTowMM4Orjsp'
            }
          }
        },
        rateLimit: {
          remaining: 4991,
          resetAt: '2021-03-10T15:32:50Z'
        }
      }
    }

    second_response = {
      data: {
        repository: {
          nameWithOwner: 'exercism/ruby',
          pullRequests: {
            nodes: [
              {
                url: 'https://github.com/exercism/ruby/pull/2',
                id: 'MDExOlB1bGxSZXF1ZXN0Mzk0NTc4ODMz',
                createdAt: '2020-03-27T06:39:20Z',
                labels: {
                  nodes: []
                },
                merged: true,
                number: 2,
                state: 'MERGED',
                author: {
                  login: 'porkostomus'
                },
                mergedBy: {
                  login: 'ErikSchierboom'
                },
                reviews: {
                  nodes: []
                }
              }
            ],
            pageInfo: {
              hasNextPage: false,
              endCursor: 'Y3Vyc29yOnYyOpK5MjAyMC0wMy0yN1QwNzozOToyMCswMTowMM4XhMuR'
            }
          }
        },
        rateLimit: {
          remaining: 4989,
          resetAt: '2021-03-10T15:32:50Z'
        }
      }
    }

    RestClient.unstub(:post)
    stub_request(:post, "https://api.github.com/graphql").
      with { |request| !request.body.include?("after:") }.
      to_return(status: 200, body: first_response.to_json, headers: { 'Content-Type': 'application/json' })

    stub_request(:post, "https://api.github.com/graphql").
      with { |request| request.body.include?("after: \\\"Y3Vyc29yOnYyOpK5MjAxOS0wMS0yMVQxNDo0OTo0MCswMTowMM4Orjsp\\\"") }.
      to_return(status: 200, body: second_response.to_json, headers: { 'Content-Type': 'application/json' })

    Github::PullRequest::SyncRepo.('exercism/ruby')

    prs = ::Github::PullRequest.all
    assert_equal 3, prs.size

    assert_equal 'exercism/ruby', prs.first.repo
    assert_equal "MDExOlB1bGxSZXF1ZXN0NTY4NDMxMTE4", prs.first.node_id
    assert_equal 19, prs.first.number
    assert_equal "exercism/ruby", prs.first.repo
    assert_equal "ErikSchierboom", prs.first.author_username
    assert_equal "iHiD", prs.first.merged_by_username
    expected_first_data = {
      url: "https://api.github.com/repos/exercism/ruby/pulls/19",
      html_url: "https://github.com/exercism/ruby/pull/19",
      repo: 'exercism/ruby',
      pr_node_id: 'MDExOlB1bGxSZXF1ZXN0NTY4NDMxMTE4',
      pr_number: 19,
      state: "closed",
      action: "closed",
      author: "ErikSchierboom",
      labels: [],
      merged: true,
      merged_by: "iHiD",
      reviews: [{ node_id: "MDE3OlB1bGxSZXF1ZXN0UmV2aWV3NTg5NDY1MzEx", reviewer: "iHiD" }]
    }
    assert_equal expected_first_data, prs.first.data
    assert_equal 1, prs.first.reviews.size
    assert_equal "MDE3OlB1bGxSZXF1ZXN0UmV2aWV3NTg5NDY1MzEx", prs.first.reviews.first.node_id
    assert_equal "iHiD", prs.first.reviews.first.reviewer_username

    assert_equal 'exercism/ruby', prs.second.repo
    assert_equal "MDExOlB1bGxSZXF1ZXN0NTYzOTgwNTkw", prs.second.node_id
    assert_equal 8, prs.second.number
    assert_equal "exercism/ruby", prs.second.repo
    assert_equal "ErikSchierboom", prs.second.author_username
    assert_equal "iHiD", prs.second.merged_by_username
    expected_first_data = {
      url: "https://api.github.com/repos/exercism/ruby/pulls/8",
      html_url: "https://github.com/exercism/ruby/pull/8",
      repo: 'exercism/ruby',
      pr_node_id: 'MDExOlB1bGxSZXF1ZXN0NTYzOTgwNTkw',
      pr_number: 8,
      state: "closed",
      action: "closed",
      author: "ErikSchierboom",
      labels: [],
      merged: true,
      merged_by: "iHiD",
      reviews: [{ node_id: "MDE3OlB1bGxSZXF1ZXN0UmV2aWV3NTg0MzAyODk0", reviewer: "ErikSchierboom" }]
    }
    assert_equal expected_first_data, prs.second.data
    assert_equal 1, prs.second.reviews.size
    assert_equal "MDE3OlB1bGxSZXF1ZXN0UmV2aWV3NTg0MzAyODk0", prs.second.reviews.first.node_id
    assert_equal "ErikSchierboom", prs.second.reviews.first.reviewer_username

    assert_equal 'exercism/ruby', prs.third.repo
    assert_equal "MDExOlB1bGxSZXF1ZXN0Mzk0NTc4ODMz", prs.third.node_id
    assert_equal 2, prs.third.number
    assert_equal "exercism/ruby", prs.third.repo
    assert_equal "porkostomus", prs.third.author_username
    assert_equal "ErikSchierboom", prs.third.merged_by_username
    expected_third_data = {
      url: "https://api.github.com/repos/exercism/ruby/pulls/2",
      html_url: "https://github.com/exercism/ruby/pull/2",
      repo: 'exercism/ruby',
      pr_node_id: 'MDExOlB1bGxSZXF1ZXN0Mzk0NTc4ODMz',
      pr_number: 2,
      state: "closed",
      action: "closed",
      author: "porkostomus",
      labels: [],
      merged: true,
      merged_by: "ErikSchierboom",
      reviews: []
    }
    assert_equal expected_third_data, prs.third.data
    assert_empty prs.third.reviews
  end

  test "imports pull request without author" do
    response = {
      data: {
        repository: {
          nameWithOwner: 'exercism/ruby',
          pullRequests: {
            nodes: [
              {
                url: 'https://github.com/exercism/ruby/pull/19',
                id: 'MDExOlB1bGxSZXF1ZXN0NTY4NDMxMTE4',
                createdAt: '2021-02-05T15:29:25Z',
                labels: {
                  nodes: []
                },
                merged: true,
                number: 19,
                state: 'MERGED',
                author: nil,
                mergedBy: {
                  login: 'iHiD'
                },
                reviews: {
                  nodes: [
                    {
                      id: 'MDE3OlB1bGxSZXF1ZXN0UmV2aWV3NTg5NDY1MzEx',
                      author: {
                        login: 'iHiD'
                      }
                    }
                  ]
                }
              }
            ],
            pageInfo: {
              hasNextPage: false,
              endCursor: 'Y3Vyc29yOnYyOpK5MjAxOS0wMS0yMVQxNDo0OTo0MCswMTowMM4Orabc'
            }
          }
        },
        rateLimit: {
          remaining: 4991,
          resetAt: '2021-03-10T15:32:50Z'
        }
      }
    }

    RestClient.unstub(:post)
    stub_request(:post, "https://api.github.com/graphql").
      to_return(status: 200, body: response.to_json, headers: { 'Content-Type': 'application/json' })

    Github::PullRequest::SyncRepo.('exercism/ruby')

    pr = ::Github::PullRequest.find_by(node_id: 'MDExOlB1bGxSZXF1ZXN0NTY4NDMxMTE4')
    assert pr.author_username.nil?
  end

  test "imports pull request that wasn't merged" do
    response = {
      data: {
        repository: {
          nameWithOwner: 'exercism/ruby',
          pullRequests: {
            nodes: [
              {
                url: 'https://github.com/exercism/ruby/pull/19',
                id: 'MDExOlB1bGxSZXF1ZXN0NTY4NDMxMTE4',
                createdAt: '2021-02-05T15:29:25Z',
                labels: {
                  nodes: []
                },
                merged: false,
                number: 19,
                state: 'MERGED',
                author: {
                  login: 'ErikSchierboom'
                },
                mergedBy: nil,
                reviews: {
                  nodes: [
                    {
                      id: 'MDE3OlB1bGxSZXF1ZXN0UmV2aWV3NTg5NDY1MzEx',
                      author: {
                        login: 'iHiD'
                      }
                    }
                  ]
                }
              }
            ],
            pageInfo: {
              hasNextPage: false,
              endCursor: 'Y3Vyc29yOnYyOpK5MjAxOS0wMS0yMVQxNDo0OTo0MCswMTowMM4Orabc'
            }
          }
        },
        rateLimit: {
          remaining: 4991,
          resetAt: '2021-03-10T15:32:50Z'
        }
      }
    }

    RestClient.unstub(:post)
    stub_request(:post, "https://api.github.com/graphql").
      to_return(status: 200, body: response.to_json, headers: { 'Content-Type': 'application/json' })

    Github::PullRequest::SyncRepo.('exercism/ruby')

    pr = ::Github::PullRequest.find_by(node_id: 'MDExOlB1bGxSZXF1ZXN0NTY4NDMxMTE4')
    assert pr.merged_by_username.nil?
  end

  test "imports pull request review without reviewer" do
    response = {
      data: {
        repository: {
          nameWithOwner: 'exercism/ruby',
          pullRequests: {
            nodes: [
              {
                url: 'https://github.com/exercism/ruby/pull/19',
                id: 'MDExOlB1bGxSZXF1ZXN0NTY4NDMxMTE4',
                createdAt: '2021-02-05T15:29:25Z',
                labels: {
                  nodes: []
                },
                merged: true,
                number: 19,
                state: 'MERGED',
                author: {
                  login: 'ErikSchierboom'
                },
                mergedBy: {
                  login: 'iHiD'
                },
                reviews: {
                  nodes: [
                    {
                      id: 'MDE3OlB1bGxSZXF1ZXN0UmV2aWV3NTg5NDY1MzEx',
                      author: nil
                    }
                  ]
                }
              }
            ],
            pageInfo: {
              hasNextPage: false,
              endCursor: 'Y3Vyc29yOnYyOpK5MjAxOS0wMS0yMVQxNDo0OTo0MCswMTowMM4Orabc'
            }
          }
        },
        rateLimit: {
          remaining: 4991,
          resetAt: '2021-03-10T15:32:50Z'
        }
      }
    }

    RestClient.unstub(:post)
    stub_request(:post, "https://api.github.com/graphql").
      to_return(status: 200, body: response.to_json, headers: { 'Content-Type': 'application/json' })

    Github::PullRequest::SyncRepo.('exercism/ruby')

    review = ::Github::PullRequestReview.find_by(node_id: 'MDE3OlB1bGxSZXF1ZXN0UmV2aWV3NTg5NDY1MzEx')
    assert review.reviewer_username.nil?
  end
end
