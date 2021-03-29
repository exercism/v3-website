require "test_helper"

class Solution::SearchUserSolutionsTest < ActiveSupport::TestCase
  test "no options returns everything" do
    user = create :user
    solution_1 = create :concept_solution, user: user
    solution_2 = create :practice_solution, user: user

    # Someone else's solution
    create :concept_solution

    assert_equal [solution_2, solution_1], Solution::SearchUserSolutions.(user)
  end

  test "criteria" do
    user = create :user
    javascript = create :track, title: "JavaScript", slug: "javascript"
    ruby = create :track, title: "Ruby"
    js_bob = create :concept_exercise, title: "Bob", track: javascript
    ruby_food = create :concept_exercise, title: "Food Chain", track: ruby
    ruby_bob = create :concept_exercise, title: "Bob", track: ruby

    js_bob_solution = create :practice_solution, user: user, exercise: js_bob
    ruby_food_solution = create :concept_solution, user: user, exercise: ruby_food
    ruby_bob_solution = create :concept_solution, user: user, exercise: ruby_bob

    assert_equal [ruby_bob_solution, ruby_food_solution, js_bob_solution], Solution::SearchUserSolutions.(user)
    assert_equal [ruby_bob_solution, ruby_food_solution, js_bob_solution],
      Solution::SearchUserSolutions.(user, criteria: " ")
    assert_equal [ruby_bob_solution, ruby_food_solution], Solution::SearchUserSolutions.(user, criteria: "ru")
    assert_equal [ruby_bob_solution, js_bob_solution], Solution::SearchUserSolutions.(user, criteria: "bo")
    assert_equal [ruby_bob_solution], Solution::SearchUserSolutions.(user, criteria: "r bo")
  end

  test "status" do
    user = create :user
    published = create :practice_solution, user: user, completed_at: Time.current, published_at: Time.current
    completed = create :practice_solution, user: user, completed_at: Time.current
    in_progress = create :concept_solution, user: user

    assert_equal [in_progress, completed, published], Solution::SearchUserSolutions.(user, status: nil)
    assert_equal [in_progress], Solution::SearchUserSolutions.(user, status: :in_progress)
    assert_equal [in_progress], Solution::SearchUserSolutions.(user, status: 'in_progress')
    assert_equal [completed, published], Solution::SearchUserSolutions.(user, status: :all_completed)
    assert_equal [completed, published], Solution::SearchUserSolutions.(user, status: 'all_completed')
    assert_equal [published], Solution::SearchUserSolutions.(user, status: :published)
    assert_equal [published], Solution::SearchUserSolutions.(user, status: 'published')
    assert_equal [completed], Solution::SearchUserSolutions.(user, status: :not_published)
    assert_equal [completed], Solution::SearchUserSolutions.(user, status: 'not_published')
  end

  test "mentoring_status" do
    user = create :user
    finished = create :concept_solution, user: user, mentoring_status: :finished
    in_progress = create :concept_solution, user: user, mentoring_status: :in_progress
    requested = create :concept_solution, user: user, mentoring_status: :requested
    none = create :concept_solution, user: user, mentoring_status: :none

    assert_equal [none, requested, in_progress, finished], Solution::SearchUserSolutions.(user, mentoring_status: nil)

    assert_equal [none], Solution::SearchUserSolutions.(user, mentoring_status: :none)
    assert_equal [none], Solution::SearchUserSolutions.(user, mentoring_status: 'none')

    assert_equal [requested], Solution::SearchUserSolutions.(user, mentoring_status: :requested)
    assert_equal [requested], Solution::SearchUserSolutions.(user, mentoring_status: 'requested')

    assert_equal [in_progress], Solution::SearchUserSolutions.(user, mentoring_status: :in_progress)
    assert_equal [in_progress], Solution::SearchUserSolutions.(user, mentoring_status: 'in_progress')

    assert_equal [finished], Solution::SearchUserSolutions.(user, mentoring_status: :finished)
    assert_equal [finished], Solution::SearchUserSolutions.(user, mentoring_status: 'finished')
  end

  test "pagination" do
    user = create :user
    solution_1 = create :concept_solution, user: user
    solution_2 = create :concept_solution, user: user

    assert_equal [solution_2], Solution::SearchUserSolutions.(user, page: 1, per: 1)
    assert_equal [solution_1], Solution::SearchUserSolutions.(user, page: 2, per: 1)
    assert_equal [solution_2, solution_1], Solution::SearchUserSolutions.(user, page: 1, per: 2)
    assert_empty Solution::SearchUserSolutions.(user, page: 2, per: 2)

    # Check it uses defaults for invalid values
    assert_equal [solution_2, solution_1], Solution::SearchUserSolutions.(user, page: 0, per: 0)
    assert_equal [solution_2, solution_1], Solution::SearchUserSolutions.(user, page: 'foo', per: 'bar')
  end

  test "sort oldest first" do
    user = create :user
    old_solution = create :concept_solution, user: user
    new_solution = create :concept_solution, user: user

    assert_equal [old_solution, new_solution], Solution::SearchUserSolutions.(user, order: "oldest_first")
  end

  test "sort newest first by default" do
    user = create :user
    old_solution = create :concept_solution, user: user
    new_solution = create :concept_solution, user: user

    assert_equal [new_solution, old_solution], Solution::SearchUserSolutions.(user)
  end
end
