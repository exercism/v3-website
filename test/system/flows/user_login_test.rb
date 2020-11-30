require "application_system_test_case"

module Flows
  class UserLoginTest < ApplicationSystemTestCase
    include ShowMeTheCookies

    test "user logs in via Github and is remembered" do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ provider: "github", uid: "123" })
      create :user, :not_onboarded, uid: "123", provider: "github", confirmed_at: Date.new(2016, 12, 25)

      visit new_user_session_path
      click_on "Sign in with GitHub"
      assert_text "Onboarding"
      expire_cookies
      visit new_user_session_path
      assert_text "Onboarding"

      OmniAuth.config.test_mode = false
    end
  end
end
