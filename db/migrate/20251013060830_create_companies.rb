class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :company_code, null: false
      t.string :name
      t.string :email
      t.string :website
      t.string :territory
      t.text :address
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :companies, :company_code, unique: true
  end
end
