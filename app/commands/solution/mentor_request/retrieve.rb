class Solution
  class MentorRequest
    class Retrieve
      include Mandate

      REQUESTS_PER_PAGE = 10

      def self.requests_per_page
        REQUESTS_PER_PAGE
      end

      def initialize(user,
                     page: 1,
                     sorted: true,
                     paginated: true,
                     criteria: nil,
                     order: nil,
                     track_slug: nil,
                     exercise_slugs: nil)
        @user = user
        @page = page
        @sorted = sorted
        @paginated = paginated
        @criteria = criteria
        @order = order
        @track_slug = track_slug
        @exercise_slugs = exercise_slugs
      end

      def call
        setup!
        filter!
        search!
        sort! if sorted?
        paginate! if paginated?

        @requests
      end

      private
      attr_reader :user, :page, :sorted, :paginated, :criteria, :order, :track_slug, :exercise_slugs

      def sorted?
        sorted
      end

      def paginated?
        paginated
      end

      def setup!
        @requests = Solution::MentorRequest.
          joins(:solution).
          includes(solution: [:user, { exercise: :track }]).
          pending.
          unlocked.
          where.not('solutions.user_id': user.id)
      end

      def filter!
        if exercise_slugs.present?
          filter_exercises!
        else
          filter_track!
        end
      end

      def filter_track!
        return if track_slug.blank?

        @requests = @requests.
          joins(solution: :track).
          where('tracks.slug': track_slug)
      end

      def filter_exercises!
        return if track_slug.blank?
        return if exercise_slugs.blank?

        @requests = @requests.
          joins(solution: { exercise: :track }).
          where('tracks.slug': track_slug).
          where('exercises.slug': exercise_slugs)
      end

      def search!
        return if criteria.blank?

        # TODO: This is just a stub implementation
        @requests = @requests.joins(:user).where("users.name LIKE ?", "%#{criteria}%")
      end

      def sort!
        # TODO: This is just a stub implementation
        case order
        when "exercise"
          @requests = @requests.joins(solution: :exercise).order("exercises.name ASC")
        when "student"
          @requests = @requests.joins(:user).order("users.name ASC")
        when "recent"
          @requests = @requests.order("solution_mentor_requests.created_at DESC")
        else
          @requests = @requests.order("solution_mentor_requests.created_at")
        end
      end

      def paginate!
        @requests = @requests.
          page(page).per(self.class.requests_per_page)
      end
    end
  end
end
