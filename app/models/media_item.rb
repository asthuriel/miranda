class MediaItem < ActiveRecord::Base
  validates :title, presence: true
  validates :tmdb_id, presence: true

  belongs_to :parent, :class_name => "MediaItem"
  has_many :media_items, dependent: :delete_all, foreign_key: :parent_id #:class_name => "MediaItem"

  def serializable_hash(options={})
    options[:except] ||= [:overview, :created_at, :updated_at]
    super(options)
  end
end
