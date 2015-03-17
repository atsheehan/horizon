class Identity < ActiveRecord::Base
  belongs_to :user

  validates :user,
    presence: true

  validates :uid,
    presence: true,
    uniqueness: { scope: :provider }

  validates :provider,
    presence: true,
    inclusion: { in: ['github', 'launch_pass'] }

  def self.find_or_create_from_omniauth(auth)
    account_keys = { uid: auth["uid"], provider: auth["provider"] }

    identity = find_or_initialize_by(account_keys)
    identity.user ||= User.new
    identity.user.email = auth["info"]["email"]
    if identity.provider == 'github'
      identity.user.username = auth["info"]["nickname"]
      split_name = (auth["info"]["name"] || '').split(" ", 2)
      identity.user.first_name = split_name[0]
      identity.user.last_name = split_name[1]
    else
      identity.user.username = auth["info"]["username"]
      identity.user.first_name = auth["info"]["first_name"]
      identity.user.last_name = auth["info"]["last_name"]
    end
    if identity.user.save
      identity.save
    end
    identity
  end
end
