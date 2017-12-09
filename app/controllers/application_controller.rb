class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  PERMISSIBLE_ATTRIBUTES = %i(name organizer_flg avatar avatar_cache)

  def after_sign_in_path_for(resource)
    if current_user.sign_in_count == 1
      unless current_user.organizer_flg
        new_artist_path
      else
        new_organizer_path
      end
    else
      root_path
    end
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
    end
end
