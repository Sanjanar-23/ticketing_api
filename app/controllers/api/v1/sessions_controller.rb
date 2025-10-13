class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create]

  protected

  def after_sign_in_path_for(_resource)
    root_path
  end

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'Logged in successfully' }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end
