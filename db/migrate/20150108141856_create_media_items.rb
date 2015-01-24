class CreateMediaItems < ActiveRecord::Migration
  def change
    create_table :media_items do |t|
      t.string :title, null: false, default: "", index: true
      t.date :release_date, index: true
      t.string :tagline, null: false, default: ""
      t.text :overview, null: false, default: ""
      t.text :cast, null: false, default: ""
      t.integer :tmdb_id, index: true
      t.string :backdrop_path, null: false, default: ""
      t.string :poster_path, null: false, default: ""

      t.timestamps null: false
    end
  end
end
