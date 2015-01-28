class Recommendation < ActiveRecord::Base
  belongs_to :recipient, :class_name => "User"
  belongs_to :sender, :class_name => "User"
  belongs_to :media_item
  belongs_to :spot

  validates :recipient, presence: true
  validates :sender, presence: true
  validates :pubdate, presence: true
  validates :media_item, presence: true
  #validates :spot, presence: true

  after_initialize :set_pubdate
  after_save :after_save

  def serializable_hash(options={})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end

  private
    def set_pubdate
      if new_record?
        self.pubdate ||= DateTime.now
      end
    end

    def after_save
      notif = Notification.create(
        recipient: self.recipient,
        sender: self.sender,
        category: 4,
        reference_id: self.spot.id
      )
    end
end
