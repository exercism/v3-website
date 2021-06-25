class Submission::Analysis < ApplicationRecord
  extend Mandate::Memoize

  serialize :data, JSON

  belongs_to :submission

  scope :ops_successful, -> { where(ops_status: 200) }

  memoize
  def has_comments?
    comment_blocks.present?
  end

  memoize
  def num_comments_by_type
    TYPES.index_with { |_t| 0 }.tap do |vals|
      comment_blocks.count do |block|
        type = block.try(:fetch, 'type', DEFAULT_TYPE).try(:to_sym) || DEFAULT_TYPE
        vals[type] += 1
      end
    end
  end

  %i[essential actionable informative celebratory].each do |type|
    define_method "num_#{type}_comments" do
      num_comments_by_type[type]
    end

    define_method "has_#{type}_comments?" do
      send("num_#{type}_comments").positive?
    end
  end

  def summary
    data[:summary].presence
  end

  memoize
  def comments
    repo = Git::WebsiteCopy.new

    comments = comment_blocks.map do |block|
      if block.is_a?(Hash)
        template = block['comment']
        params = block['params']
        type = block['type']
      else
        template = block
      end

      markdown = repo.analysis_comment_for(template) % (params || {}).symbolize_keys

      {
        type: type&.to_sym || DEFAULT_TYPE,
        html: Markdown::Parse.(markdown)
      }
    rescue StandardError => e
      # TODO: Open this issue on the relevant track's analyzer repo
      Bugsnag.notify(e)
      nil
    end

    comments.compact.sort_by { |c| TYPES.index(c[:type]) }
  end

  def ops_success?
    ops_status == 200
  end

  def ops_errored?
    !ops_success?
  end

  private
  def comment_blocks
    data[:comments].to_a
  end

  memoize
  def data
    HashWithIndifferentAccess.new(super)
  end

  TYPES = %i[essential actionable informative celebratory].freeze
  DEFAULT_TYPE = :informative
  private_constant :TYPES, :DEFAULT_TYPE
end
