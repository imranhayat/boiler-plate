# frozen_string_literal: true

# :User Model:
class User < ApplicationRecord
  # Roles
  rolify
  # Devise modules
  devise :invitable, :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :invitable, :omniauthable,
         omniauth_providers: %i[google_oauth2 facebook]
  # Validations
  validates_uniqueness_of :email
  # User Balance Settings
  monetize :balance_cents, as: 'balance'
  # Paperclip Settings
  has_attached_file :profile_pic, styles: { medium: '300x300',
                                            small: '150x150' },
                                  default_url: '/avatar.png'
  validates_attachment_content_type :profile_pic,
                                    content_type: /\Aimage\/.*\z/

  after_create :assign_default_role

  def assign_default_role
    user = self
    user.add_role(:normal) if user.roles.blank?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = SecureRandom.hex(8)
    end
  end

  def self.with_role_normal_count
    Role.find_by_name('normal').users.count
  end
end
