FactoryBot.define do
  factory :notification, class: "Notifications::MentorStartedDiscussionNotification" do
    user
    params do
      {
        discussion: create(:solution_mentor_discussion)
      }
    end
  end
end
