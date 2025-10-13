class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.string :company_code
      t.string :company_name
      t.string :customer_name
      t.string :email
      t.string :subject
      t.string :issue
      t.text :description
      t.text :note
      t.string :assigned_to
      t.string :status
      t.references :contact, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
