# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_10_16_054555) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "company_code", null: false
    t.string "name"
    t.string "email"
    t.string "website"
    t.string "territory"
    t.text "address"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "street"
    t.string "state"
    t.string "country"
    t.string "city"
    t.string "zip_code"
    t.index ["company_code"], name: "index_companies_on_company_code", unique: true
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "company_code"
    t.string "company_name"
    t.string "website"
    t.string "phone"
    t.string "email"
    t.string "customer_name"
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_contacts_on_company_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti", unique: true
  end

  create_table "ticket_emails", force: :cascade do |t|
    t.bigint "ticket_id", null: false
    t.string "from"
    t.text "to"
    t.text "cc"
    t.string "subject"
    t.text "body"
    t.datetime "sent_at"
    t.string "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_emails_on_ticket_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "company_code"
    t.string "company_name"
    t.string "customer_name"
    t.string "email"
    t.string "subject"
    t.string "issue"
    t.text "description"
    t.text "note"
    t.string "assigned_to"
    t.string "status"
    t.bigint "contact_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "priority"
    t.index ["contact_id"], name: "index_tickets_on_contact_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "territory"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "companies", "users"
  add_foreign_key "contacts", "companies"
  add_foreign_key "contacts", "users"
  add_foreign_key "ticket_emails", "tickets"
  add_foreign_key "tickets", "contacts"
  add_foreign_key "tickets", "users"
end
