class AddPriorityToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :priority, :string
  end
end
