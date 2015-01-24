class Spot < ActiveRecord::Base
  belongs_to :user
  belongs_to :media_item

  validates :user, presence: true
  validates :media_item, presence: true
  validates :pubdate, presence: true

  before_save :before_save
  after_initialize :set_pubdate

  private
    def set_pubdate
      if new_record?
        self.pubdate ||= DateTime.now
      end
    end

    def before_save
      coder = HTMLEntities.new

      if (not self.user.email == 'albertodlh@gmail.com') #REFACTOR: Needs a settings table for users who can use html tags in comments
        self.review = coder.encode(self.review, :basic)
      end
    end
end
