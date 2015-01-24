class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :spot, index: true
      t.datetime :pubdate, index: true
      t.text :content, null: false, default: ""

      t.timestamps null: false
    end
    add_foreign_key :comments, :users
    add_foreign_key :comments, :spots
  end
end
