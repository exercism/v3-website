class User
  class ReputationToken
    class AwardForPullRequests
      include Mandate

      def call
        pull_requests.find_each do |pr|
          User::ReputationToken::AwardForPullRequest.(pr.data)
        rescue StandardError => e
          Rails.logger.error "Error syncing pull request reputation for #{pr.repo}/#{pr.number}: #{e}"
        end
      end

      private
      def pull_requests
        ::Git::PullRequest.left_joins(:reviews)
      end
    end
  end
end
