module V2ETL
  class Migrate
    include Mandate

    def call; end

    def migrate_users
      # TODO: Remove current_sign_in_at
      # TODO: Remove last_sign_in_at
      # TODO: Remove sign_in_count
      # TODO: Remove current_sign_in_ip
      # TODO: Remove last_sign_in_ip
      # TODO: Move default_allow_comments to preferences
      # TODO: Migrate is_mentor to became_mentor_at
      # TODO: Remove full_width_code_panes
      # TODO: Remove may_edit_changelog
      # TODO: Migrate show_v3_patience_modal
      # TODO: Migrate show_introducing_research_modal
    end
  end
end
