require "test_helper"
require_relative '../../../lib/v2_etl/migrate'

module V2ETL
  class MigrateTest < ActiveSupport::TestCase
    self.use_transactional_tests = false

    setup do
      `mv db/schema.rb db/schema.v3.rb`
      `cp db/schema.v2.rb db/schema.rb`
      `rake db:test:prepare`
    end

    teardown do
      `mv db/schema.v3.rb db/schema.rb`
    end

    def test_runs_cleanly
      V2ETL::Migrate.()

      # Check we can still create all the factories
      FactoryBot.factories.map(&:name).each do |factory|
        # Run each in isolation
        ActiveRecord::Base.transaction do
          create factory
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
