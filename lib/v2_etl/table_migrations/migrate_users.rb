module V2ETL
  module TableMigrations
    class MigrateUsers
      include Mandate

      def call
        # Remove tracking columns
        remove_column :users, :current_sign_in_at
        remove_column :users, :last_sign_in_at
        remove_column :users, :sign_in_count
        remove_column :users, :current_sign_in_ip
        remove_column :users, :last_sign_in_ip

        # Remove redundant columns
        remove_column :users, :full_width_code_panes
        remove_column :users, :may_edit_changelog

        # Add missing columns
        add_column :users, :github_username, :string
        add_column :users, :became_mentor_at, :datetime

        # Add indexes
        add_index :users, %w[provider uid], unique: true

        # TODO: Move default_allow_comments to preferences
        # TODO: Migrate show_v3_patience_modal
        # TODO: Migrate show_introducing_research_modal
      end

      delegate :add_column, :remove_column, :add_index,
        to: :connection
      def connection
        ActiveRecord::Base.connection
      end
    end
  end
end
