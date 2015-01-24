class CreateTagAlongs < ActiveRecord::Migration
  def change
    create_table :tag_alongs do |t|
      t.references :tagger, index: true
      t.references :tagged, index: true

      t.timestamps null: false
    end
    add_foreign_key :tag_alongs, :users, column: :tagger_id, primary_key: :id
    add_foreign_key :tag_alongs, :users, column: :tagged_id, primary_key: :id

    add_index :tag_alongs, [:tagger_id, :tagged_id], :unique => true
  end
end
