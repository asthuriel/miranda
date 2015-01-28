class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :comments, dependent: :delete_all
  has_many :spots, dependent: :delete_all
  has_many :veredicts, dependent: :delete_all

  has_many :tag_alongs, dependent: :delete_all, :foreign_key => :tagger_id
  has_many :tag_alongs, dependent: :delete_all, :foreign_key => :tagged_id

  has_many :notifications, dependent: :delete_all, :foreign_key => :recipient_id
  has_many :notifications, dependent: :delete_all, :foreign_key => :sender_id
  #has_many :tagged_alongs, :class_name => "TagAlong", :foreign_key => :tagged_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  validates :email, :username, uniqueness: true, presence: true
  validates :full_name, presence: true

  before_save :before_save

  def role_enum
    [['User', 'user'], ['Administrator', 'admin']]
  end

  def is_admin?
    self.role == 'admin' ? true : false
  end

  def self.find_for_google_oauth2(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    if user
      if user.avatar_url != data["image"]
        user.avatar_url = data["image"]
      end
      if user.full_name != data["name"]
        user.full_name != data["name"]
      end
    end

    if false
      unless user
        user = User.create(
          username:  data["email"],
          email: data["email"],
          password: Devise.friendly_token[0,20],
          full_name: data["name"],
          avatar_url: data["image"]
          # provider: access_token.provider,
          # uid: access_token.uid,
        )
      end
    end
    user
  end

  def self.fetch_known_users(token, uid = nil)
    known_users = []
    known_users.concat(get_contacts(token, uid))
    #known_users.concat(get_gplus(token))
    return known_users.uniq
  end

  def serializable_hash(options={})
    options[:only] ||= [:id, :username, :full_name, :bio, :avatar_url, :tag_id]
    super(options)
  end

  private
    def before_save
      #coder = HTMLEntities.new
      #self.full_name = coder.encode(self.full_name, :basic)
      # full_name is stored as is, so consider it's html unsafe.
    end

    def self.fetch_google_collection(token, type)
      uri_string = ""
      if type == "contacts"
        uri_string = "https://www.google.com/m8/feeds/contacts/default/full?oauth_token="+token+"&max-results=5000&alt=json"
      elsif type == "gplus"
        uri_string = "https://www.googleapis.com/plus/v1/people/me/people/visible?oauth_token="+token+"&max-results=100&alt=json"
      end
      uri = URI.parse(uri_string)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      return ActiveSupport::JSON.decode(response.body)
    end

    def self.get_contacts(token, uid = nil)
      email_array = []
      user_array = []
      contacts = fetch_google_collection(token, "contacts")
      entries = contacts["feed"]["entry"]
      if entries
        my_people = []
        entries.each do |entry|
          person = {}
          emails = entry["gd$email"]
          if emails
            emails.each do |email|
              person = {
                name: entry["title"]["$t"],
                email: email["address"]
              }
              my_people.push person
              email_array.push(person[:email])
            end
          end
        end

        users = User.where('users.email in (?)', email_array)
        if uid
          users = users.where('users.id != ? and users.id not in (select t.tagged_id from tag_alongs as t where t.tagger_id = ?)', uid, uid)
        end
        users.each do |user|
          user_array.push user.id
        end
      end
      return user_array
    end

    def self.get_gplus(token, uid = nil)
      id_array = []
      user_array = []
      contacts = fetch_google_collection(token, "gplus")
      entries = contacts["items"]
      if entries
        my_people = []
        entries.each do |entry|
          person = {
            name: entry["displayName"],
            id: entry["id"]
          }
          my_people.push person
          id_array.push(person[:id])
        end

        users = User.where('users.google_id in (?)', id_array)
        if uid
          users = users.where('users.id != ? and users.id not in (select t.tagged_id from tag_alongs as t where t.tagger_id = ?)', uid, uid)
        end
        users.each do |user|
          user_array.push user.id
        end
      end
      return user_array
    end
end
