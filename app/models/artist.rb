class Artist < ActiveRecord::Base
  belongs_to :user, dependent: :destroy

  mount_uploader :avatar, AvatarUploader
  mount_uploader :singing, SingingUploader
  mount_uploader :play_video, PlayVideoUploader

  enum genre: { ロック:"1", メタル:"2", ハードコア:"3", アコースティック:"4", シンガー:"5"}

  has_many :concerns, foreign_key:"follower_id", dependent: :destroy
  has_many :reverse_concerns, foreign_key:"followed_id", class_name: "Concern", dependent: :destroy

  has_many :followed_users, through: :concerns, source: :followed
  has_many :followers, through: :reverse_concerns, source: :follower

end
