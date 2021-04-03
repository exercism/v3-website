class SerializeTrack
  include Mandate

  def initialize(track, user_track)
    @track = track
    @user_track = user_track || UserTrack::External.new(track)
  end

  def call
    {
      id: track.slug,
      title: track.title,
      num_concepts: user_track.num_concepts,
      num_exercises: user_track.num_exercises,
      web_url: Exercism::Routes.track_url(track),
      icon_url: track.icon_url,
      tags: map_tags(track.tags),
      updated_at: user_track.updated_at.iso8601,

      # TODO: Set these
      is_new: true,
    }.merge(user_data_for_track)
  end

  private
  attr_reader :track, :user_track

  def map_tags(tags)
    tags.to_a.map do |tag|
      Track::TAGS.dig(*tag.split('/'))
    rescue StandardError
      nil
    end.compact
  end

  def user_data_for_track
    return {} if !user_track || user_track.external?

    {
      is_joined: true,
      num_learnt_concepts: user_track.num_concepts_learnt,
      num_completed_exercises: user_track.num_completed_exercises
    }
  end
end
