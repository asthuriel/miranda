class CreateVeredicts < ActiveRecord::Migration
  def change
    create_table :veredicts do |t|
      t.references :spot, index: true
      t.references :user, index: true
      t.datetime :pubdate
      t.integer :veredict, null: false, default: 0

      t.timestamps null: false
    end
    add_foreign_key :veredicts, :spots
    add_foreign_key :veredicts, :users
  end
end
