require "application_system_test_case"
require_relative "../../support/capybara_helpers"

module Components
  module Student
    class EditorTest < ApplicationSystemTestCase
      include CapybaraHelpers

      test "user runs tests" do
        user = create :user
        create :user_auth_token, user: user
        solution = create :concept_solution, user: user

        use_capybara_host do
          visit edit_solution_path(solution.uuid)
          click_on "Run tests"
          wait_for_submission
          2.times { wait_for_websockets }
          test_run = create :submission_test_run,
            submission: Submission.last,
            status: "pass",
            ops_status: 200,
            tests: [{ name: :test_a_name_given, status: :pass, output: "Hello" }]
          Submission::TestRunsChannel.broadcast!(test_run)

          assert_text "Status: pass"
          assert_text "Passed: test_a_name_given"
        end
      end

      test "user sees previous test results" do
        user = create :user
        create :user_auth_token, user: user
        solution = create :concept_solution, user: user
        submission = create :submission, solution: solution
        create :submission_test_run,
          submission: submission,
          status: "pass",
          ops_status: 200,
          tests: [{ name: :test_a_name_given, status: :pass, output: "Hello" }]

        use_capybara_host do
          visit edit_solution_path(solution.uuid)

          assert_text "Status: pass"
          assert_text "Passed: test_a_name_given"
        end
      end

      test "user sees errors" do
        user = create :user
        create :user_auth_token, user: user
        solution = create :concept_solution, user: user
        create :submission, solution: solution

        use_capybara_host do
          visit edit_solution_path(solution.uuid)
          click_on "Run tests"

          assert_text "No files you submitted have changed since your last submission"
        end
      end

      test "user submits code" do
        Submission::File.any_instance.stubs(:content)
        use_capybara_host do
          user = create :user
          create :user_auth_token, user: user
          solution = create :concept_solution, user: user

          visit edit_solution_path(solution.uuid)
          click_on "Run tests"
          wait_for_submission
          2.times { wait_for_websockets }
          test_run = create :submission_test_run,
            submission: Submission.last,
            status: "pass",
            ops_status: 200,
            tests: [{ name: :test_a_name_given, status: :pass, output: "Hello" }]
          create :submission_file, submission: Submission.last
          Submission::TestRunsChannel.broadcast!(test_run)
          click_on "Submit"

          assert_text "Iteration 1", wait: 5
        end
      end

      private
      def wait_for_submission
        assert_text "Status: queued", wait: 2
      end
    end
  end
end
