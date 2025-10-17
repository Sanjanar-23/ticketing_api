class Api::V1::TicketsController < ApiController
  before_action :set_ticket, only: [:show, :update, :destroy]

  def index
    render json: Ticket.all
  end

  def show
    render json: @ticket
  end

  def create
    ticket = Ticket.new(ticket_params)
    if ticket.save
      render json: ticket, status: :created
    else
      render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @ticket.update(ticket_params)
      render json: @ticket
    else
      render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket.destroy
    head :no_content
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:contact_id, :user_id, :subject, :issue, :description, :note, :assigned_to, :status)
  end
end
