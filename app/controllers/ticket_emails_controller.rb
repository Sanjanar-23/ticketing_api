class TicketEmailsController < WebControllerBase
  before_action :set_ticket
  before_action :set_ticket_email, only: [:show]

  def create
    @ticket_email = @ticket.ticket_emails.build(ticket_email_params)
    @ticket_email.from = current_user.email
    @ticket_email.sent_at = Time.current

    if @ticket_email.save
      begin
        TicketMailer.send_email(@ticket_email).deliver_now
        flash[:notice] = 'Email sent successfully!'
      rescue => e
        flash[:alert] = "Email could not be sent: #{e.message}"
      end
    else
      flash[:alert] = 'Failed to send email. Please check the form.'
    end

    redirect_to @ticket
  end

  def show
    # Show individual email details
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def set_ticket_email
    @ticket_email = @ticket.ticket_emails.find(params[:id])
  end

  def ticket_email_params
    params.require(:ticket_email).permit(:to, :cc, :subject, :body, :tags)
  end
end
