class AddTvFieldsToMediaItems < ActiveRecord::Migration
  def change
    add_reference :media_items, :parent, index: true
    add_foreign_key :media_items, :media_items, column: :parent_id, primary_key: :id
    add_column :media_items, :category, :integer, null: false, default: 0
    add_column :media_items, :season_number, :integer
    add_column :media_items, :episode_number, :integer
  end
end
