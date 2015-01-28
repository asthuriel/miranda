class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :spot

  validates :user, presence: true
  validates :spot, presence: true
  validates :pubdate, presence: true
  validates :content, presence: true

  before_save :before_save
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

    def before_save
      coder = HTMLEntities.new

      #if (not self.gravatar or self.gravatar=='')
      #  gravatar_id = Digest::MD5::hexdigest(self.email).downcase
      #  self.gravatar = "http://gravatar.com/avatar/#{gravatar_id}?s=100&d=wavatar"
      #end

      if (not self.user.email == 'albertodlh@gmail.com') #REFACTOR: Needs a settings table for users who can use html tags in comments
        self.content = coder.encode(self.content, :basic)
      end
    end

    def after_save
      if self.spot.user != self.user
        notif = Notification.create(
          recipient: self.spot.user,
          sender: self.user,
          category: 1,
          reference_id: self.spot.id
        )
      end
    end
end
