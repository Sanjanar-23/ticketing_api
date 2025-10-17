class TicketsController < WebControllerBase
  def index
    @q = params[:q].to_s.strip
    scope = Ticket.includes(:contact, :user).all
    if @q.present?
      like = "%#{@q}%"
      scope = scope.where(
        Ticket.arel_table[:company_name].matches(like)
        .or(Ticket.arel_table[:issue].matches(like))
        .or(Ticket.arel_table[:subject].matches(like))
      )
    end
    @tickets = scope.order(created_at: :desc)
  end

  def show
    @ticket = Ticket.includes(:ticket_emails, :contact, :user).find(params[:id])
  end

  def new
    @ticket = Ticket.new
    @ticket.user_id = current_user.id if user_signed_in?

    # If coming from company context, filter contacts by company
    if params[:company_id].present?
      @company = Company.find(params[:company_id])
      @contacts = company_contacts(@company.id)
    else
      @contacts = company_contacts
    end
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.user_id = current_user.id if user_signed_in? && @ticket.user_id.blank?

    if @ticket.save
      # Redirect back to company page if created from company context
      if params[:company_id].present?
        redirect_to company_path(params[:company_id]), notice: 'Ticket was successfully created.'
      else
        redirect_to @ticket, notice: 'Ticket was successfully created.'
      end
    else
      # Reload contacts for the form
      if params[:company_id].present?
        @company = Company.find(params[:company_id])
        @contacts = company_contacts(@company.id)
      else
        @contacts = company_contacts
      end
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @ticket = Ticket.includes(:user).find(params[:id])
    @contacts = company_contacts
  end

  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update(ticket_params)
      # Redirect back to company page if edited from company context
      if params[:company_id].present?
        redirect_to company_path(params[:company_id]), notice: 'Ticket was successfully updated.'
      else
        redirect_to @ticket, notice: 'Ticket was successfully updated.'
      end
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
    params.require(:ticket).permit(:contact_id, :user_id, :subject, :issue, :description, :note, :assigned_to, :status, :priority)
  end
end
