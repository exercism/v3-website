require_relative "table_migration"

module V2ETL
  module TableMigrations
    class MigrateIterations < TableMigration
      include Mandate

      def table_name
        "iterations"
      end

      def model
        Iteration
      end

      def call
        # Create a submission for each iteration
        ActiveRecord::Base.connection.execute(<<-SQL)
        INSERT INTO submissions (
          id, uuid, solution_id,#{' '}
          tests_status, representation_status, analysis_status, submitted_via,
          git_slug, git_sha, created_at, updated_at
        )
        SELECT#{' '}
          iterations.id, UUID(), iterations.solution_id,
          0, 0, 0, 'cli',
          '', '', NOW(), NOW()
        FROM iterations
        SQL

        # Add a couple of straight-forward columns
        add_non_nullable_column :submission_id, :bigint, "id"
        add_non_nullable_column :uuid, :string do
          SecureRandom.compact_uuid
        end

        # TODO: Calculate idx
        add_non_nullable_column :idx, :integer, "1", limit: 1

        # TODO: Set to true if it's the final iteration
        add_column :published, :boolean, default: false
      end
    end
  end
end
