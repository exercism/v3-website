module V2ETL
  module DataProcessors
    class ProcessSolutions
      include Mandate

      def call
        Solution.find_each do |solution|
          solution.update!(
            status: solution.send(:determine_status),
            mentoring_status: solution.send(:determine_mentoring_status),
            iteration_status: solution.iterations.last&.status.to_s
          )
        end

        Solution.where(status: :started).
          where(downloaded_at: nil).
          destroy_all
      end
    end
  end
end
