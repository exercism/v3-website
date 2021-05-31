require_relative './base_test_case'

module API
  class CommunitySolutionsControllerTest < API::BaseTestCase
    #########
    # INDEX #
    #########
    test "index should return top 20 serialized correctly" do
      users = Array.new(25) do |idx|
        create(:user, handle: "handle-#{idx}").tap do |user|
          create :user_reputation_period, user: user, period: :forever, reputation: idx
        end
      end.reverse

      get api_contributors_path, headers: @headers, as: :json

      assert_response :success
      contextual_data = User::ReputationToken::CalculateContextualData.(users.map(&:id))
      paginated_users = Kaminari.paginate_array(users, total_count: 25).page(1).per(20)
      expected = SerializePaginatedCollection.(
        paginated_users,
        serializer: SerializeContributors,
        serializer_kwargs: { starting_rank: 1, contextual_data: contextual_data }
      ).to_json
      assert_equal expected, response.body
    end

    #########
    # INDEX #
    #########
    test "index should proxy correctly" do
      track = create :track
      user_1 = create(:user, handle: 'foobar')
      user_2 = create(:user, handle: 'foo')
      create :user_reputation_period, user: user_1, track_id: track.id
      create :user_reputation_period, user: user_2, track_id: track.id

      period = 'forever'
      category =  'everything'
      user_handle = 'fo'
      page = '1'

      User::ReputationPeriod::Search.expects(:call).with(
        period: period,
        category: category,
        track_id: track.id,
        user_handle: user_handle,
        page: page
      ).returns(User.page(1).per(20))

      User::ReputationToken::CalculateContextualData.expects(:call).with(
        [user_1.id, user_2.id],
        period: period,
        category: category,
        track_id: track.id
      ).returns(
        user_1.id => mock(reputation: 1, activity: ""),
        user_2.id => mock(reputation: 1, activity: "")
      )

      get api_contributors_path(
        period: period,
        category: category,
        track: track.slug,
        user_handle: user_handle,
        page: page
      ), headers: @headers, as: :json

      assert_response :success
    end
  end
end