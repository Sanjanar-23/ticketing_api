class PasswordsController < Devise::PasswordsController
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
  def edit
    super
  end

  # Override to use custom layout
  def update
    super
  end
end
