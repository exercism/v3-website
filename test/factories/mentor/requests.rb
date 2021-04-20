FactoryBot.define do
  factory :mentor_request, class: 'Mentor::Request' do
    solution { create :practice_solution }
    comment_markdown { "I could do with some help here" }

    trait :pending do
      status { :pending }
    end

    trait :fulfilled do
      status { :fulfilled }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :locked do
      locked_until { Time.current + 30.minutes }
      locked_by { create :user }
    end
  end
end
