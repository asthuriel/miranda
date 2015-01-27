class AddSpotToRecommendations < ActiveRecord::Migration
  def change
    add_reference :recommendations, :spot, index: true
    add_foreign_key :recommendations, :spots
  end
end
