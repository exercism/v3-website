module ToolingJob
  class Process
    include Mandate

    initialize_with :id

    def call
      attrs = client.get_item(
        table_name: Exercism.config.dynamodb_tooling_jobs_table,
        key: { id: id },
        attributes_to_get: %i[
          type
          iteration_uuid
          execution_status
          output
        ]
      ).item

      case attrs['type']
      when "test_runner"
        Iteration::TestRun::Process.(
          attrs["iteration_uuid"],
          attrs["execution_status"],
          "Nothing to report", # TODO
          JSON.parse(download_file(attrs["output"]["results.json"]))
        )
      when "representer"
        Iteration::Representation::Process.(
          attrs["iteration_uuid"],
          attrs["execution_status"],
          "Nothing to report", # TODO
          download_file(attrs["output"]["representation.txt"]),
          JSON.parse(download_file(attrs["output"]["mapping.json"]))
        )
      when "analyzer"
        Iteration::Analysis::Process.(
          attrs["iteration_uuid"],
          attrs["execution_status"],
          "Nothing to report", # TODO
          JSON.parse(download_file(attrs["output"]["analysis.json"]))
        )
      end

      client.update_item(
        table_name: Exercism.config.dynamodb_tooling_jobs_table,
        key: { id: id },
        expression_attribute_names: {
          "#JS": "job_status"
        },
        expression_attribute_values: {
          ":js": "processed"
        },
        update_expression: "SET #JS = :js"
      )
    end

    memoize
    def client
      ExercismConfig::SetupDynamoDBClient.()
    end

    def download_file(key)
      s3_client = ExercismConfig::SetupS3Client.()
      s3_obj = s3_client.get_object(
        bucket: Exercism.config.aws_tooling_jobs_bucket,
        key: key
      )
      s3_obj.body.read
    end
  end
end
