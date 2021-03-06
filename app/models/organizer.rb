class Organizer < ActiveRecord::Base
  before_save :geocode_full_address

  has_many :events
  belongs_to :user

  has_many :follows, foreign_key:"follower_id", dependent: :destroy
  has_many :reverse_follows, foreign_key:"followed_id", class_name: "Concern", dependent: :destroy

  has_many :followed_users, through: :follows, source: :followed
  has_many :followers, through: :reverse_follows, source: :follower

  mount_uploader :avatar, AvatarUploader

  def geocode_full_address
      # coords = Geocoder.coordinates(
      #   self.prefecture + self.city + self.address # 県名 + 市町村名 + 丁目番地
      # )
      # self.latitude = coords[0]
      # self.longitude = coords[1]
  end

end
