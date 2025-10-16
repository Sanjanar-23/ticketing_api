class CreateTicketEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :ticket_emails do |t|
      t.references :ticket, null: false, foreign_key: true
      t.string :from
      t.text :to
      t.text :cc
      t.string :subject
      t.text :body
      t.datetime :sent_at
      t.string :tags

      t.timestamps
    end
  end
end
