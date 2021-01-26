require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  test "statuses start at pending" do
    submission = create :submission
    assert submission.tests_not_queued?
    assert submission.representation_not_queued?
    assert submission.analysis_not_queued?
  end

  test "submissions get their solution's git data" do
    solution = create :concept_solution
    submission = create :submission, solution: solution

    assert_equal solution.git_sha, submission.git_sha
    assert_equal solution.git_slug, submission.git_slug
  end

  test "exercise_representation" do
    ast = "foobar"

    # No submission_representation
    submission = create :submission
    assert_nil submission.exercise_representation

    # Ops error submission rep
    sr = create :submission_representation, submission: submission, ast: ast, ops_status: 500
    submission = Submission.find(submission.id)
    assert_nil submission.exercise_representation

    # Missing exercise_reprsentation
    sr.update!(ops_status: 200)
    submission = Submission.find(submission.id)
    assert_nil submission.exercise_representation

    # er present
    er = create :exercise_representation, exercise: submission.exercise, ast_digest: sr.ast_digest
    submission = Submission.find(submission.id)
    assert_equal er, submission.exercise_representation
  end

  test "has_automated_feedback? with representation" do
    submission = create :submission
    refute submission.has_automated_feedback?

    create :submission_representation, ast_digest: "foobar", submission: submission
    submission = Submission.find(submission.id)
    refute submission.has_automated_feedback?

    er = create :exercise_representation, ast_digest: "foobar", exercise: submission.exercise
    submission = Submission.find(submission.id)
    refute submission.has_automated_feedback?

    er.update!(feedback_markdown: "foobar", feedback_author: create(:user))
    submission = Submission.find(submission.id)
    assert submission.has_automated_feedback?
  end

  test "has_automated_feedback? with analysis" do
    submission = create :submission
    refute submission.has_automated_feedback?

    sa = create :submission_analysis, submission: submission
    submission = Submission.find(submission.id)
    refute submission.reload.has_automated_feedback?

    sa.update(data: { comments: ['asd'] })
    submission = Submission.find(submission.id)
    assert submission.reload.has_automated_feedback?
  end
end
