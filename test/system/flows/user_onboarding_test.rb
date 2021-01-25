require "application_system_test_case"

module Flows
  class UserOnboardingTest < ApplicationSystemTestCase
    test "user is onboarded before being able to do anything on the website" do
      user = create :user, :not_onboarded
      sign_in!(user)

      visit root_path
      find('label', text: "I accept Exercism's Terms of Service").click
      find('label', text: "I accept Exercism's Privacy Policy").click
      click_on "Save & Get Started"

      assert_page :staging
    end
  end
end
