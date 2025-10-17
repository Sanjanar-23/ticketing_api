class WebControllerBase < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  layout 'application'

  protected

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  # Helper method to get contacts for a specific company
  def company_contacts(company_id = nil)
    if company_id.present?
      Contact.where(company_id: company_id).includes(:company).order(:customer_name)
    else
      Contact.includes(:company).order(:customer_name)
    end
  end
end
