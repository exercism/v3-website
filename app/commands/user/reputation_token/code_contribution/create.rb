class User
  class ReputationToken
    module CodeContribution
      class Create
        include Mandate

        initialize_with :user, :external_link, :repo, :number, :reason

        def call
          reputation_token = User::ReputationToken.create_or_find_by!(
            user: user,
            context_key: "contributed_code/#{repo}/pulls/#{number}"
          ) do |rt|
            rt.external_link = external_link
            rt.reason = reason
            rt.category = :building
          end

          reputation_token.update!(reason: reason)
        end
      end
    end
  end
end
