require "application_system_test_case"
require_relative "../../../support/capybara_helpers"

module Flows
  module CommunitySolutions
    class PublishSolutionTest < ApplicationSystemTestCase
      include CapybaraHelpers

      test "user changes a published iteration" do
        track = create :track
        exercise = create :concept_exercise, track: track
        author = create :user, handle: "author"
        create :user_track, user: author, track: track
        solution = create :concept_solution, :completed, :published, user: author, exercise: exercise
        submission = create :submission, solution: solution
        create :iteration, idx: 1, submission: submission
        submission = create :submission, solution: solution
        iteration_2 = create :iteration, idx: 2, submission: submission
        solution.update!(published_iteration: iteration_2)

        use_capybara_host do
          sign_in!(author)
          visit track_exercise_community_solution_url(track, exercise, "author")
          click_on "Publish settings"
          assert_button "2", disabled: true
          choose "All iterations"
          click_on "Submit"

          assert_button "1"
          assert_button "2", disabled: true
        end
      end

      test "other user can not change the published iteration" do
        track = create :track
        exercise = create :concept_exercise, track: track
        author = create :user, handle: "author"
        create :user_track, user: author, track: track
        solution = create :concept_solution, :completed, :published, user: author, exercise: exercise
        submission = create :submission, solution: solution
        create :iteration, idx: 1, submission: submission
        submission = create :submission, solution: solution
        iteration_2 = create :iteration, idx: 2, submission: submission
        solution.update!(published_iteration: iteration_2)

        use_capybara_host do
          sign_in!
          visit track_exercise_community_solution_url(track, exercise, "author")

          assert_no_button "Publish settings"
        end
      end
    end
  end
end
