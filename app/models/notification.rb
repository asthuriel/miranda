class Notification < ActiveRecord::Base
  belongs_to :recipient, :class_name => "User"
  belongs_to :sender, :class_name => "User"

  validates :recipient, presence: true
  validates :sender, presence: true
  validates :pubdate, presence: true
  validates :category, presence: true
  validates :status, presence: true

  after_initialize :set_pubdate

  def type_enum
    [['Tag Along', 0], ['Comment', 1], ['Agreed', 2], ['Booed', 3]]
  end

  def status_enum
    [['Unread', 0], ['Viewed', 1], ['Opened', 2]]
  end

  def self.new_count(user)
    return Notification.where(recipient: user, status: 0).length
  end

  # def as_json(options={})
  #   super(only: [:recipient, :sender], include: [:addresses])
  # end

  private
    def set_pubdate
      if new_record?
        self.pubdate ||= DateTime.now
      end
    end
end
