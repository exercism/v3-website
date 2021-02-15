class Notification < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::AssetUrlHelper
  include Webpacker::Helper
  extend Mandate::Memoize

  enum email_status: { pending: 0, skipped: 1, sent: 2, failed: 3 }

  belongs_to :user

  scope :read, -> { where.not(read_at: nil) }
  scope :unread, -> { where(read_at: nil) }

  before_create do
    self.version = latest_i18n_version
    self.uniqueness_key = "#{user_id}-#{type_key}-#{guard_params}"
  end

  def read?
    read_at.present?
  end

  def read!
    update_column(:read_at, Time.current)
  end

  def text
    # TODO: Add test for sanitizing here.
    I18n.t(
      "notifications.#{i18n_key}.#{version}",
      i18n_params.transform_values { |v| sanitize(v) }
    ).strip
  end

  # TODO
  def url
    "/"
  end

  def type_key
    type.split("::").last.underscore.split("_notification").first.to_sym
  end

  # This maps
  # {discussion: Solution::MentorDiscussion.find(186)}
  # to
  # {discussion: "gid://exercism/Solution::MentorDiscussion/186"}
  #
  # Any non-object params are left as the were passed in.
  def params=(hash)
    self[:params] = hash.transform_values do |v|
      v.respond_to?(:to_global_id) ? v.to_global_id.to_s : v
    end
  end

  # This reverses params= to explode back out
  # {discussion: "gid://exercism/Solution::MentorDiscussion/186"}
  # to
  # {discussion: Solution::MentorDiscussion.find(186)}
  #
  # Any non-object params are left as the were passed in.
  private
  memoize
  def params
    super.each_with_object({}) do |(k, v), h|
      h[k.to_sym] = GlobalID::Locator.locate(v) || v
    end
  end

  def latest_i18n_version
    I18n.backend.send(:init_translations)
    I18n.backend.send(:translations)[:en][:notifications][i18n_key].keys.first
  rescue StandardError
    raise "Missing i18n key for this notification"
  end

  def i18n_key
    self.class.name.underscore.split('/').last.gsub(/_notification$/, '').to_sym
  end
end
