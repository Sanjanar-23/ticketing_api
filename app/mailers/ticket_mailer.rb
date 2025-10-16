class TicketMailer < ApplicationMailer
  def send_email(ticket_email)
    @ticket_email = ticket_email
    @ticket = ticket_email.ticket
    @contact = @ticket.contact
    @user = @ticket.user

    mail(
      from: @ticket_email.from,
      to: @ticket_email.to,
      cc: @ticket_email.cc,
      subject: @ticket_email.subject
    )
  end
end
