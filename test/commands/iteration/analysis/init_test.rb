require 'test_helper'

class Iteration::Analysis::InitTest < ActiveSupport::TestCase
  test "calls to publish_message" do
    solution = create :concept_solution
    iteration_uuid = SecureRandom.compact_uuid
    RestClient.expects(:post).with('http://analyzer.example.com/iterations',
                                   iteration_uuid: iteration_uuid,
                                   language_slug: solution.track.slug,
                                   exercise_slug: solution.exercise.slug,
                                   version_slug: nil)
    Iteration::Analysis::Init.(iteration_uuid, solution.track.slug, solution.exercise.slug)
  end

  test "uses version_slug" do
    solution = create :concept_solution
    iteration_uuid = SecureRandom.compact_uuid
    version_slug = SecureRandom.uuid

    RestClient.expects(:post).with('http://analyzer.example.com/iterations',
                                   iteration_uuid: iteration_uuid,
                                   language_slug: solution.track.slug,
                                   exercise_slug: solution.exercise.slug,
                                   version_slug: version_slug)
    Iteration::Analysis::Init.(iteration_uuid, solution.track.slug, solution.exercise.slug, version_slug)
  end
end
