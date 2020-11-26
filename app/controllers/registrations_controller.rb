class RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!
  before_action :configure_permitted_parameters

  def create
    super do |user|
      return unless user.persisted?

      User::Bootstrap.(user)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name handle])
  end

  def after_inactive_sign_up_path_for(_resource)
    confirmation_required_path
  end
end
