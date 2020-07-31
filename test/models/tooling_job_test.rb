require 'test_helper'

class ToolingJobTest < ActiveSupport::TestCase
  test "create! proxies to dynamodb" do
    freeze_time do
      type = "foobars"
      uuid = SecureRandom.uuid
      SecureRandom.expects(:uuid).returns(uuid)

      # TODO: Test via the db rather than mocks
      client = Exercism.config.dynamodb_client
      client.expects(:put_item).with(
        table_name: Exercism.config.dynamodb_tooling_jobs_table,
        item: {
          id: uuid,
          created_at: Time.current.utc.to_i,
          type: type,
          job_status: :pending,
          foo: :bar
        }
      )

      ToolingJob.create!(type, { foo: :bar })
    end
  end

  test "process! proxies to test run" do
    id = SecureRandom.uuid
    type = "test_runner"
    iteration_uuid = "iteration-uuid"
    execution_status = "job-status"
    result = { 'some' => 'result' }

    item = {
      "type" => type,
      "iteration_uuid" => iteration_uuid,
      "execution_status" => execution_status,
      "result" => result
    }

    Iteration::TestRun::Process.expects(:call).with(
      iteration_uuid,
      execution_status,
      "Nothing to report",
      result
    )

    # TODO: Create some factory methods for this
    # and test via the db rather than mocks
    client = Exercism.config.dynamodb_client
    client.expects(:get_item).with(
      table_name: Exercism.config.dynamodb_tooling_jobs_table,
      key: { id: id },
      attributes_to_get: %i[
        type
        iteration_uuid
        execution_status
        result
      ]
    ).returns(mock(item: item))

    ToolingJob.process!(id)
  end
end
