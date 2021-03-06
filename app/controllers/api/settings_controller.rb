module API
  class SettingsController < BaseController
    def update
      permitted = params.require(:user).permit(
        :name, :location, :bio,
        pronoun_parts: []
      )

      if current_user.update(permitted)
        render json: {}, status: :ok
      else
        render_400(:failed_validations, errors: current_user.errors)
      end
    end

    def sudo_update
      unless current_user.valid_password?(params.dig(:user, :sudo_password))
        Rails.logger.debug "Wrong password"

        return render_400(:incorrect_password)
      end

      if params.dig(:user, :password).present?
        user_params = params[:user]
        unless user_params[:password] == user_params[:password_confirmation]
          Rails.logger.debug "Wrong password"

          return render_400(:passwords_dont_match)
        end
      end

      permitted = params.
        require(:user).
        permit(:handle, :email, :password, :password_confirmation)

      return render json: {}, status: :ok if current_user.update(permitted)
    end
  end
end
