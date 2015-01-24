class AddProviderInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, null: false, default: ""
    add_column :users, :google_id, :string, null: false, default: ""
  end
end
