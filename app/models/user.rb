class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :artist, dependent: :destroy
  has_many :organizer, dependent: :destroy

  has_many :concerns, foreign_key:"follower_id", dependent: :destroy
  has_many :reverse_concerns, foreign_key:"followed_id", class_name: "Concern", dependent: :destroy

  has_many :followed_users, through: :concerns, source: :followed
  has_many :followers, through: :reverse_concerns, source: :follower

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user
      user = User.new(
        name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
        image_url: auth.info.image,
        password: Devise.friendly_token[0, 20]
      )
      user.skip_confirmation!
      user.save(validate: false)
    end
    user
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user
      user = User.new(
        name: auth.info.nickname,
        image_url: auth.info.image,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
        password: Devise.friendly_token[0, 20]
      )
      user.skip_confirmation!
      user.save
    end
    user
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  def update_with_password(params, *options)
    if provider.blank?
      super
    else
      params.delete :current_password
      update_without_password(params, *options)
    end
  end

  def follow!(other_user)
    concerns.create!(followed_id: other_user.id)
  end

  def following?(other_user)
    concerns.find_by(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    concerns.find_by(followed_id: other_user.id).destroy
  end

end
