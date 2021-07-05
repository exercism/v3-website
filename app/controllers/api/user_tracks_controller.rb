# TODO: This is just a stub
module API
  class UserTracksController < BaseController
    before_action :use_track

    def activate_learning_mode
      @user_track.update(practice_mode: false)
      render_track_mode
    end

    def activate_practice_mode
      @user_track.update(practice_mode: true)
      render_track_mode
    end

    def reset
      UserTrack::Reset.(@user_track)

      render json: {
        user_track: {
          links: {
            self: track_url(@track)
          }
        }
      }
    end

    def leave
      UserTrack::Reset.(@user_track) if params[:reset]
      @user_track.destroy

      render json: {
        user_track: {
          links: {
            self: tracks_url
          }
        }
      }
    end

    private
    def use_track
      @track = Track.find(params[:id])
      # TODO: Rescue and handle
      @user_track = UserTrack.for!(current_user, @track)
    end

    def render_track_mode
      render json: {
        user_track: {
          links: {
            self: track_url(@track)
          }
        }
      }
    end
  end
end
