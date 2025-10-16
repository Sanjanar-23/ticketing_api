class AddAddressFieldsToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :street, :string
    add_column :companies, :state, :string
    add_column :companies, :country, :string
    add_column :companies, :city, :string
    add_column :companies, :zip_code, :string
  end
end
