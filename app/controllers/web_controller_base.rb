class WebControllerBase < ActionController::Base
  # before_action :authenticate_user!
  layout 'application'

  protected

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
