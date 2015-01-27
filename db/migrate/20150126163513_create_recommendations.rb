class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.references :recipient, index: true
      t.references :sender, index: true
      t.references :media_item, index: true
      t.datetime :pubdate

      t.timestamps null: false
    end
    add_foreign_key :recommendations, :users, column: :recipient_id, primary_key: :id
    add_foreign_key :recommendations, :users, column: :sender_id, primary_key: :id
    add_foreign_key :recommendations, :media_items
  end
end
