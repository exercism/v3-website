require "application_system_test_case"
require_relative "../../support/capybara_helpers"
require_relative "../../support/ace_helpers"

module Components
  module Flows
    class EditSolutionTest < ApplicationSystemTestCase
      include CapybaraHelpers
      include CodeMirrorHelpers

      test "user submits code" do
        Submission::File.any_instance.stubs(:content)
        use_capybara_host do
          user = create :user
          create :user_auth_token, user: user
          bob = create :concept_exercise
          solution = create :concept_solution, user: user, exercise: bob

          sign_in!(user)
          visit edit_track_exercise_path(solution.track, solution.exercise)
          click_on "Run Tests"
          wait_for_submission
          2.times { wait_for_websockets }
          test_run = create :submission_test_run,
            submission: Submission.last,
            ops_status: 200,
            raw_results: {
              status: "pass",
              tests: [{ name: :test_a_name_given, status: :pass, output: "Hello" }]
            }
          create :submission_file, submission: Submission.last
          Submission::TestRunsChannel.broadcast!(test_run)
          within(".lhs-footer") { click_on "Submit" }

          assert_text "Iteration 1", wait: 5
        end
      end

      test "user submits code via results panel" do
        Submission::File.any_instance.stubs(:content)
        use_capybara_host do
          user = create :user
          create :user_auth_token, user: user
          bob = create :concept_exercise
          solution = create :concept_solution, user: user, exercise: bob

          sign_in!(user)
          visit edit_track_exercise_path(solution.track, solution.exercise)
          click_on "Run Tests"
          wait_for_submission
          2.times { wait_for_websockets }
          test_run = create :submission_test_run,
            submission: Submission.last,
            ops_status: 200,
            raw_results: {
              status: "pass",
              tests: [{ name: :test_a_name_given, status: :pass, output: "Hello" }]
            }
          create :submission_file, submission: Submission.last
          Submission::TestRunsChannel.broadcast!(test_run)
          within(".success-box") { click_on "Submit" }

          assert_text "Iteration 1", wait: 5
        end
      end

      private
      def wait_for_submission
        assert_text "Running tests..."
      end
    end
  end
end
