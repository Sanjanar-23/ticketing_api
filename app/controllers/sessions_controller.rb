class SessionsController < Devise::SessionsController
  layout 'authentication'

  # Override to use custom layout
  def new
    super
  end

  # Override to use custom layout
  def create
    super
  end

  # Override to use custom layout
  def destroy
    super
  end
end
