require "test_helper"

class ContributorTeam::Membership::CreateOrUpdateTest < ActiveSupport::TestCase
  test "creates contributor team membership" do
    user = create :user
    team = create :contributor_team

    Github::Team::AddMember.stubs(:call)

    ContributorTeam::Membership::CreateOrUpdate.(
      user,
      team,
      seniority: :junior,
      visible: true
    )

    assert_equal 1, ContributorTeam::Membership.count
    m = ContributorTeam::Membership.last

    assert_equal user, m.user
    assert_equal team, m.team
    assert_equal :junior, m.seniority
    assert m.visible
  end

  test "updates contributor team membership" do
    user = create :user
    team = create :contributor_team
    membership = create :contributor_team_membership, user: user, team: team, seniority: :senior, visible: false

    # Sanity check
    assert_equal user, membership.user
    assert_equal team, membership.team
    assert_equal :senior, membership.seniority
    refute membership.visible

    ContributorTeam::Membership::CreateOrUpdate.(
      user,
      team,
      seniority: :junior,
      visible: true
    )

    membership.reload
    assert_equal user, membership.user
    assert_equal team, membership.team
    assert_equal :junior, membership.seniority
    assert membership.visible
  end

  test "add contributor to github team if new membership" do
    user = create :user
    team = create :contributor_team

    Github::Team::AddMember.expects(:call).with(team.github_name, user.github_username)

    ContributorTeam::Membership::CreateOrUpdate.(
      user,
      team,
      seniority: :junior,
      visible: true
    )
  end

  test "does not add contributor to github team if existing membership" do
    user = create :user
    team = create :contributor_team
    create :contributor_team_membership, user: user, team: team, seniority: :senior, visible: false

    Github::Team::AddMember.expects(:call).never

    ContributorTeam::Membership::CreateOrUpdate.(
      user,
      team,
      seniority: :junior,
      visible: true
    )
  end

  test "idempotent" do
    user = create :user
    team = create :contributor_team, type: :track_maintainers

    Github::Team::AddMember.stubs(:call)

    assert_idempotent_command do
      ContributorTeam::Membership::CreateOrUpdate.(
        user,
        team,
        seniority: :junior,
        visible: true
      )
    end
  end
end
