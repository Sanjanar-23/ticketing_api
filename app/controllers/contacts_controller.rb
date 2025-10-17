class ContactsController < WebControllerBase
  def index
    if params[:company_id].present?
      @company = Company.find(params[:company_id])
      @contacts = Contact.includes(:company, :user).where(company_id: @company.id)
    else
      @contacts = Contact.includes(:company, :user).all
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
    @contact.company_id = params[:company_id] if params[:company_id].present?
    @company = Company.find(params[:company_id]) if params[:company_id].present?
  end

  def create
    @contact = Contact.new(contact_params)

    # Set user_id from company if not provided
    if @contact.user_id.blank? && @contact.company_id.present?
      company = Company.find(@contact.company_id)
      @contact.user_id = company.user_id
    end

    if @contact.save
      # Redirect back to company page if created from company context
      if params[:contact][:company_id].present?
        redirect_to company_path(params[:contact][:company_id]), notice: 'Contact was successfully created.'
      else
        redirect_to @contact, notice: 'Contact was successfully created.'
      end
    else
      @company = Company.find(params[:contact][:company_id]) if params[:contact][:company_id].present?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @contact = Contact.includes(:user).find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update(contact_params)
      # Redirect back to company page if edited from company context
      if params[:contact][:company_id].present?
        redirect_to company_path(params[:contact][:company_id]), notice: 'Contact was successfully updated.'
      else
        redirect_to @contact, notice: 'Contact was successfully updated.'
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Contact.find(params[:id]).destroy
    redirect_to contacts_path
  end

  private

  def contact_params
    params.require(:contact).permit(:company_id, :user_id, :customer_name, :email, :phone)
  end
end
