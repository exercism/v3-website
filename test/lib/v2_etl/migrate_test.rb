require "test_helper"
require 'v2_etl'

module V2ETL
  class MigrateTest < ActiveSupport::TestCase
    def test_migration
      system('cp db/schema.v2.rb db/schema.rb')
      system('rake db:test:prepare')

      V2ETL::Migrate.()
    end

    def load_sample_data
      ActiveRecord::Base.connection.execute(<<-SQL)
        INSERT INTO `users` (`name`, `handle`, `email`, `encrypted_password`, `current_sign_in_at`, `confirmation_token`, `confirmation_sent_at`, `created_at`, `updated_at`, `show_v3_patience_modal`) VALUES ('Jeremy Walker 0.6651859383300991', 'b8beef34-8ba0-496e-8348-06735fd141d9', 'jez.walker+dacc4bf8-1b55-4010-bdda-1f7372ced6f2@gmail.com', '$2a$04$Q8JBrxb6mkuLmjgud9f2vuA0FkycRMj6LzJ/pgPsB6nMI2QQVfOzS', '2020-05-29 12:10:07', 'yZwvSYN_6JFevHzGKfxz', '2020-05-29 12:10:07', '2020-05-29 12:10:07', '2020-05-29 12:10:07', FALSE)
        INSERT INTO `communication_preferences` (`user_id`, `created_at`, `updated_at`, `token`) VALUES (1, '2020-05-29 12:10:07', '2020-05-29 12:10:07', 'dd488ed7-f0fd-418d-97da-bd83d69aaf67')
      SQL
    end
  end
end
