require "test_helper"

class TicketEmailsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get ticket_emails_create_url
    assert_response :success
  end

  test "should get show" do
    get ticket_emails_show_url
    assert_response :success
  end
end
