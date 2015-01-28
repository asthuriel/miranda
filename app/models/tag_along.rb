class TagAlong < ActiveRecord::Base
  belongs_to :tagger, :class_name => "User"
  belongs_to :tagged, :class_name => "User"

  after_save :after_save

  def serializable_hash(options={})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end

  private
    def after_save
      notif = Notification.create(
        recipient: self.tagged,
        sender: self.tagger,
        category: 0
      )
    end
end
