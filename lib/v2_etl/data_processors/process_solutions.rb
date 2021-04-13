module V2ETL
  module DataProcessors
    class ProcessSolutions
      include Mandate

      def call
        Solution.find_each(&:update_status!)
      end
    end
  end
end
