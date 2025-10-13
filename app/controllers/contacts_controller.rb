class ContactsController < ApplicationController
  def index
    @contacts = Contact.includes(:company).all
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to @contact
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update(contact_params)
      redirect_to @contact
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
