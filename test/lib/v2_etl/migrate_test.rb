require "test_helper"
require_relative '../../../lib/v2_etl/migrate'

# Some times this gets into a mess. In that situation it's best to drop
# the exercism_v3_test database entirely and recreate it (see README)

module V2ETL
  class MigrateTest < ActiveSupport::TestCase
    self.use_transactional_tests = false

    setup do
      Rails.logger.debug "#####\#####\nn#####\nStarting Migration\n#####\#####\nn#####\n"

      `cp db/schema.v2.rb db/schema.rb`

      tables = ActiveRecord::Base.connection.select_values('SELECT table_name FROM information_schema.tables WHERE TABLE_SCHEMA = "exercism_v3_test"') # rubocop:disable Layout/LineLength
      ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS=0;")
      tables.each { |table| ActiveRecord::Base.connection.drop_table(table) }
      ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS=1;")

      `RAILS_ENV=test rake db:schema:load`
    end

    teardown do
      `cp db/schema.v3.rb db/schema.rb`
    end

    def test_structural_changes_run_cleanly
      cmd = V2ETL::Migrate.new
      cmd.stubs(:migrate_data!)
      cmd.()

      # Check we can still create all the factories
      FactoryBot.factories.map(&:name).each do |factory|
        # Run each in isolation
        ActiveRecord::Base.transaction do
          create factory
          raise ActiveRecord::Rollback
        end
      end
    end

    def test_iterations_have_submissions_created; end
  end
end
