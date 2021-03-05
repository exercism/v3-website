module Git
  module Temp
    class ImportPullRequestsForRepo
      include Mandate

      initialize_with :repo

      def call
        fetch!
        create!
      end

      private
      attr_reader :repo, :pull_requests, :cursor

      def create!
        pull_requests.each do |pr|
          ::GithubPullRequest.create!(
            github_id: pr[:pull_request][:id],
            github_username: pr[:pull_request][:user][:login],
            github_repo: pr[:repository][:full_name],
            github_event: pr
          )
        rescue ActiveRecord::RecordNotUnique
          return nil
        end
      end

      def fetch!
        @cursor = nil
        @pull_requests = []

        loop do
          page_data = fetch_page!
          @pull_requests += pull_requests_from_response(page_data)

          page_info = page_data.dig(:data, :repository, :pullRequests, :pageInfo)
          @cursor = page_info[:endCursor]
          break unless page_info[:hasNextPage]

          # If the rate limit was exceeded, sleep until it resets
          rate_limit = page_data[:data][:rateLimit]
          next unless rate_limit[:remaining] <= 0

          reset_at = Time.zone.parse(rate_limit[:resetAt])
          seconds_until_reset = reset_at - Time.zone.now
          sleep(seconds_until_reset.ceil)
        end
      end

      def fetch_page!
        query = "{
          repository(owner: \"#{repo_owner}\", name: \"#{repo_name}\") {
            nameWithOwner
            pullRequests(first: 100, states:[CLOSED, MERGED] #{", after: \"#{cursor}\"" if cursor}) {
              nodes {
                url
                databaseId
                labels(first: 100) {
                  nodes {
                    name
                  }
                }
                merged
                number
                author {
                  login
                }
                reviews(first: 100) {
                  nodes {
                    author {
                      login
                    }
                  }
                }
              }
              pageInfo {
                hasNextPage
                endCursor
              }
            }
          }
          rateLimit {
            remaining
            resetAt
          }
        }".freeze

        octokit_client.post("https://api.github.com/graphql", { query: query }.to_json)
      end

      def pull_requests_from_response(response)
        # We're transforming the GraphQL response to the format used by the REST API.
        # This allows us to work with pull requests using a single code path.
        response[:data][:repository][:pullRequests][:nodes].map do |pr|
          next if pr[:author].nil? # In rare cases the PR author is null

          {
            action: 'closed',
            pull_request: {
              id: pr[:databaseId],
              user: {
                login: pr[:author][:login]
              },
              url: "https://api.github.com/repos/#{response[:data][:repository][:nameWithOwner]}/pulls/#{pr[:number]}",
              html_url: pr[:url],
              labels: pr[:labels][:nodes].map { |node| node[:name] },
              state: 'closed',
              number: pr[:number],
              merged: pr[:merged],
              reviews: pr[:reviews][:nodes].map do |node|
                next if node[:author].nil? # In rare cases the review author is null

                { user: { login: node[:author][:login] } }
              end.compact
            },
            repository: {
              full_name: response[:data][:repository][:nameWithOwner]
            }
          }
        end.compact
      end

      memoize
      def repo_owner
        repo.split('/').first
      end

      memoize
      def repo_name
        repo.split('/').second
      end

      memoize
      def octokit_client
        Octokit::Client.new(access_token: Exercism.secrets.github_access_token)
      end
    end
  end
end
