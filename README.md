# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Ticketing API (Rails)

## Setup

1. Ensure PostgreSQL is running.
2. Install gems:

```bash
bundle install
```

3. Create and migrate DB:

```bash
bin/rails db:create db:migrate db:seed
```

4. Run server:

```bash
bin/rails s
```

## Models
- User: name, email, territory
- Company: company_code (auto), name, email, website, territory, address, user_id
- Contact: belongs to company and user; copies company_code/name/website
- Ticket: belongs to contact and user; copies contact/customer/company fields; status in [new, open, pending, resolved, closed]

## API
Base: `/api/v1`

Example flow:

```bash
# Create a user
curl -X POST http://localhost:3000/api/v1/users -H 'Content-Type: application/json' \
  -d '{"user": {"name":"Agent","email":"agent@example.com","territory":"East"}}'

# Create a company (user_id required)
curl -X POST http://localhost:3000/api/v1/companies -H 'Content-Type: application/json' \
  -d '{"company": {"name":"Acme","email":"info@acme.test","website":"acme.test","territory":"East","address":"1 Road","user_id":1}}'

# Create a contact (company_id and user_id required)
curl -X POST http://localhost:3000/api/v1/contacts -H 'Content-Type: application/json' \
  -d '{"contact": {"company_id":1, "user_id":1, "customer_name":"Jane", "email":"jane@acme.test", "phone":"+1-555-0101"}}'

# Create a ticket (contact_id and user_id required)
curl -X POST http://localhost:3000/api/v1/tickets -H 'Content-Type: application/json' \
  -d '{"ticket": {"contact_id":1, "user_id":1, "subject":"Printer issue","issue":"hardware","description":"Stops printing"}}'
```

## Authentication (JWT)

Login to receive a JWT in the Authorization header:

```bash
curl -i -X POST http://localhost:3000/api/v1/login \
  -H 'Content-Type: application/json' \
  -d '{"user":{"email":"agent@example.com","password":"password"}}'
```

Use the `Authorization: Bearer <token>` header for API requests. Logout:

```bash
curl -X DELETE http://localhost:3000/api/v1/logout -H "Authorization: Bearer $TOKEN"
```

## Web UI

- Visit `http://localhost:3000/` to manage companies, contacts, and tickets.
- Since `authenticate_user!` is enabled globally, sign in via API or adjust controllers if you want public web pages.
