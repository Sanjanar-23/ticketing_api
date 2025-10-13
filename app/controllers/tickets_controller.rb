class TicketsController < ApplicationController
  def index
    @tickets = Ticket.includes(contact: :company).all
  end

  def show
    @ticket = Ticket.find(params[:id])
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save
      redirect_to @ticket
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update(ticket_params)
      redirect_to @ticket
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Ticket.find(params[:id]).destroy
    redirect_to tickets_path
  end

  private

  def ticket_params
    params.require(:ticket).permit(:contact_id, :user_id, :subject, :issue, :description, :note, :assigned_to, :status)
  end
end
