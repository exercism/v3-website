module ReactComponents
  module Dropdowns
    class Reputation < ReactComponent
      initialize_with :user

      def to_s
        super(
          "dropdowns-reputation",
          {
            reputation: user.formatted_reputation,
            is_seen: user.reputation_tokens.unseen.empty?,
            endpoint: Exercism::Routes.api_reputation_index_url(per_page: 5, order: :unseen_first)
          }
        )
      end
    end
  end
end
