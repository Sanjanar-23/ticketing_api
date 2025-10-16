class DashboardController < WebControllerBase
  def index
    # Get filter parameter for overdue tickets (default to 30 days)
    @overdue_filter = params[:overdue_filter] || '30'
    @overdue_days = @overdue_filter.to_i

    # Calculate date threshold for overdue tickets
    @overdue_threshold = @overdue_days.days.ago

    # Get ticket statistics
    @total_tickets = Ticket.count
    @ticket_statuses = Ticket.group(:status).count

    # Get overdue tickets (open tickets older than threshold)
    @overdue_tickets = Ticket.includes(:contact, :user)
                            .where(status: ['new', 'open', 'pending'])
                            .where('created_at < ?', @overdue_threshold)
                            .order(created_at: :asc)
                            .limit(10)

    # Get tickets by priority
    @tickets_by_priority = Ticket.group(:priority).count

    # Get recent tickets for activity feed
    @recent_tickets = Ticket.includes(:contact, :user)
                           .order(created_at: :desc)
                           .limit(5)

    # Calculate average response time (mock data for now)
    @avg_response_time = {
      first_response: 2.5,
      resolution: 4.8
    }
  end
end
