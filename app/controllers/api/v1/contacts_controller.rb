class Api::V1::ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :update, :destroy]

  def index
    render json: Contact.all
  end

  def show
    render json: @contact
  end

  def create
    contact = Contact.new(contact_params)
    if contact.save
      render json: contact, status: :created
    else
      render json: { errors: contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    head :no_content
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:company_id, :user_id, :customer_name, :email, :phone)
  end
end
