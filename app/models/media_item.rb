class MediaItem < ActiveRecord::Base
  validates :title, presence: true
  validates :tmdb_id, presence: true

  belongs_to :parent, :class_name => "MediaItem"
  has_many :media_items, dependent: :delete_all, foreign_key: :parent_id #:class_name => "MediaItem"
end
