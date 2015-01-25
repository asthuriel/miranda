class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.references :user, index: true
      t.references :media_item, index: true
      t.text :review
      t.integer :veredict
      t.datetime :pubdate, index: true

      t.timestamps null: false
    end
    add_foreign_key :spots, :users
    add_foreign_key :spots, :media_items
  end
end
