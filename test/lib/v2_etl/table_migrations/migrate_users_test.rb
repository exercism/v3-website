require "test_helper"
require_relative '../../../../lib/v2_etl/table_migrations/migrate_users'

module V2ETL::TableMigrations
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

    def test_migration
      V2ETL::TableMigrations::MigrateUsers.()

      # Test we can still create a user
      create :user
    end
  end
end
