require 'test_helper'

class SerializeIterationTestRunTest < ActiveSupport::TestCase
  test "test successful run" do
    test = {
      'name' => 'test_a_name_given',
      'status' => 'pass',
      'output' => 'foobar'
    }
    test_run = create :iteration_test_run,
      ops_status: 200,
      status: "pass",
      tests: [test]

    actual = SerializeIterationTestRun.(test_run)

    expected = {
      id: test_run.id,
      status: :pass,
      message: test_run.message,
      tests: [test]
    }
    assert_equal expected, actual
  end

  test "status: proxies fail" do
    test_run = create :iteration_test_run,
      ops_status: 200,
      status: 'fail'

    output = SerializeIterationTestRun.(test_run)

    assert_equal :fail, output[:status]
  end

  test "status: proxies error" do
    test_run = create :iteration_test_run,
      ops_status: 200,
      status: 'error'

    output = SerializeIterationTestRun.(test_run)

    assert_equal :error, output[:status]
  end

  test "status: returns error if unexpected" do
    test_run = create :iteration_test_run,
      ops_status: 200,
      status: 'foobar'

    output = SerializeIterationTestRun.(test_run)

    assert_equal :error, output[:status]
  end

  test "message: returns message if there is one" do
    message = "foobar"
    test_run = create :iteration_test_run, message: message

    output = SerializeIterationTestRun.(test_run)

    assert_equal message, output[:message]
  end

  test "message: returns nil if there is no message" do
    test_run = create :iteration_test_run,
      ops_status: 200,
      raw_results: { message: nil }

    output = SerializeIterationTestRun.(test_run)

    assert_nil output[:message]
  end

  test "ops_error returns status and message" do
    test_run = create :iteration_test_run,
      ops_status: 403,
      raw_results: { message: nil } # Override the factory

    output = SerializeIterationTestRun.(test_run)

    assert_equal "ops_error", output[:status]
    assert_equal "Some error occurred", output[:message]
  end
end
