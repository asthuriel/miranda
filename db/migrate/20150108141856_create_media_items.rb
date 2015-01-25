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
      t.integer :season_number
      t.integer :episode_number
      t.integer :category, null: false, default: 0
      t.references :parent, index: true

      t.timestamps null: false
    end

    add_foreign_key :media_items, :media_items, column: :parent_id, primary_key: :id
  end
end


