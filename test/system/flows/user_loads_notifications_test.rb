require "application_system_test_case"
require_relative "../../support/capybara_helpers"

module Flows
  class UserLoadsNotificationsTest < ApplicationSystemTestCase
    include CapybaraHelpers

    test "user views notifications" do
      user = create :user
      badge = create :rookie_badge
      create :acquired_badge_notification, user: user, params: { badge: badge }

      use_capybara_host do
        sign_in!(user)
        visit dashboard_path
        within(".c-notification") { assert_text "1" }
        find(".c-notification").click

        assert_text "You have been awarded the Rookie badge."
      end
    end
  end
end