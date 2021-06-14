require 'test_helper'

class SiteUpdateTest < ActiveSupport::TestCase
  test "text is sanitized" do
    update = SiteUpdates::NewExerciseUpdate.new
    update.define_singleton_method(:i18n_params) do
      { user: "<foo>d</foo>angerous" }
    end

    I18n.expects(:t).with(
      "site_updates.new_exercise.",
      { user: "dangerous" }
    ).returns("")

    update.text
  end

  test "rendering expanded data" do
    track = create :track
    exercise = create :concept_exercise, track: track

    author = create :user
    title = "Check this out!!"
    description = "I did something really cool :)"
    update = create :site_update, exercise: exercise, track: track, author: author, title: title, description: description

    expected = {
      author_handle: author.handle,
      author_avatar_url: author.avatar_url,
      title: title,
      description: description
    }.stringify_keys
    assert_equal expected, update.rendering_data[:expanded]
  end

  test "rendering pull request" do
    track = create :track
    exercise = create :concept_exercise, track: track

    pull_request = create :github_pull_request
    update = create :site_update, exercise: exercise, track: track, pull_request: pull_request

    expected = {
      title: pull_request.title,
      number: pull_request.number,
      url: "https://github.com/#{pull_request.repo}/pull/#{pull_request.number}",
      merged_by: pull_request.merged_by_username,
      merged_at: pull_request.updated_at.iso8601
    }.stringify_keys
    assert_equal expected, update.rendering_data[:pull_request]
  end

  test "published_at is set to now + 3.hours" do
    freeze_time do
      update = create :site_update
      assert_equal Time.current + 3.hours, update.published_at
    end
  end

  test "published scope" do
    published = create :site_update, published_at: Time.current - 1.minute
    unpublished = create :site_update, published_at: Time.current + 1.minute

    assert_equal [published, unpublished], SiteUpdate.all # Sanity
    assert_equal [published], SiteUpdate.published
  end

  test "sorted scope" do
    first = create :site_update, published_at: Time.current - 1.minute
    third = create :site_update, published_at: Time.current + 2.minutes
    second = create :site_update, published_at: Time.current

    assert_equal [third, second, first], SiteUpdate.sorted
  end

  test "for track scope" do
    ruby = create :track, slug: 'ruby'
    js = create :track, slug: 'js'
    ruby_update = create :site_update, track: ruby
    js_update = create :site_update, track: js

    assert_equal [ruby_update, js_update], SiteUpdate.all # Sanity
    assert_equal [js_update], SiteUpdate.for_track(js)
  end
end
