module ViewComponents
  module Student
    class TracksList < ViewComponent
      def initialize(data, request = default_request)
        @data = data
        @request = request
      end

      def to_s
        react_component("student-tracks-list", {
                          request: request.deep_merge({ options: { initialData: data } }),
                          status_options: STATUS_OPTIONS
                        })
      end

      STATUS_OPTIONS = [
        { value: "all", label: "All" },
        { value: "joined", label: "Joined" },
        { value: "unjoined", label: "Unjoined" }
      ].freeze
      private_constant :STATUS_OPTIONS

      private
      attr_reader :data, :request

      def default_request
        # TODO: Change this to the actual endpoint, not the test endpoint
        { endpoint: Exercism::Routes.tracks_test_components_student_tracks_list_path }
      end
    end
  end
end
