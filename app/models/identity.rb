class Identity < ActiveRecord::Base
  belongs_to :user
  validates :uid,
            presence: true,
            uniqueness: { scope: :provider }
  validates :provider, presence: true

  def self.for_oauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid)
  end
end
