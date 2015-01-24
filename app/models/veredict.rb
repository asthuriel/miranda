class Veredict < ActiveRecord::Base
  belongs_to :spot
  belongs_to :user

  after_initialize :set_pubdate

  after_save :after_save
  before_destroy :before_destroy

  private
    def set_pubdate
      if new_record?
        self.pubdate ||= DateTime.now
      end
    end

    def after_save
      if self.spot.user != self.user
        category = (self.veredict > 0) ? 2 : 3
        ver_categories = [2, 3]

        prev_notif = Notification.where(sender: self.user, reference_id: self.spot.id, category: ver_categories).first
        if prev_notif
          prev_notif.destroy
        end

        notif = Notification.create(
          recipient: self.spot.user,
          sender: self.user,
          category: category,
          reference_id: self.spot.id
        )
      end
    end

    def before_destroy
      ver_categories = [2, 3]
      prev_notif = Notification.where(sender: self.user, reference_id: self.spot.id, category: ver_categories).first
      if prev_notif
        prev_notif.destroy
      end
    end
end
