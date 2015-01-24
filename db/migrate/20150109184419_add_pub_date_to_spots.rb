class AddPubDateToSpots < ActiveRecord::Migration
  def change
    add_column :spots, :pubdate, :datetime, index: true
  end
end
