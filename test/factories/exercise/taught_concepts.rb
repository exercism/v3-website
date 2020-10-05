FactoryBot.define do
  factory :exercise_taught_concept, class: 'Exercise::TaughtConcept' do
    exercise { create :concept_exercise }
    concept { create :track_concept }
  end
end
