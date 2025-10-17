class CreateChatbots < ActiveRecord::Migration[7.1]
  def change
    create_table :chatbots do |t|
      t.text :message, null: false
      t.text :response
      t.integer :user_id
      t.integer :ticket_id
      t.string :session_id, null: false
      t.string :message_type, default: 'user' # 'user' or 'bot'
      t.boolean :is_helpful, default: nil # true, false, or nil
      t.timestamps
    end

    add_index :chatbots, :session_id
    add_index :chatbots, :user_id
    add_index :chatbots, :ticket_id
  end
end
