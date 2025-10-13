class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :company_code
      t.string :company_name
      t.string :website
      t.string :phone
      t.string :email
      t.string :customer_name
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
