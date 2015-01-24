class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :recipient, index: true
      t.references :sender, index: true
      t.integer :category, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :reference_id
      t.datetime :pubdate

      t.timestamps null: false
    end
    add_foreign_key :notifications, :users, column: :recipient, primary_key: :id
    add_foreign_key :notifications, :users, column: :sender, primary_key: :id
  end
end
