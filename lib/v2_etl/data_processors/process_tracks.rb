module V2ETL
  module DataProcessors
    class ProcessTracks
      include Mandate

      def call
        Track.find_each { |track| Git::SyncTrack.(track) }
      end
    end
  end
end
