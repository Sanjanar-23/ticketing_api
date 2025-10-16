user = User.find_or_create_by!(email: "agent@example.com") do |u|
  u.name = "Support Agent"
  u.territory = "East"
  u.password = "password"
  u.password_confirmation = "password"
end

company = Company.create!(name: "Acme Corp", email: "info@acme.test", website: "acme.test", territory: "East", address: "1 Road", user: user)

contact = Contact.create!(customer_name: "Jane Customer", email: "jane@acme.test", phone: "+1-555-0101", company: company, user: user)

Ticket.create!(contact: contact, user: user, subject: "Printer not working", issue: "hardware", description: "Stops printing after 3 pages", priority: "normal")
