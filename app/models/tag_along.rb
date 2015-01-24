class TagAlong < ActiveRecord::Base
  belongs_to :tagger, :class_name => "User"
  belongs_to :tagged, :class_name => "User"

  after_save :after_save

  private
    def after_save
      notif = Notification.create(
        recipient: self.tagged,
        sender: self.tagger,
        category: 0
      )
    end
end
