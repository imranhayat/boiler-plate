class User < ApplicationRecord
  # Roles
  rolify
  # Devise modules
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :invitable
  # Validations
  validates_uniqueness_of :email
  # User Balance Settings
  monetize :balance_cents, as: 'balance'  
  # Paperclip Settings
  has_attached_file :profile_pic, styles: { medium: '300x300', small: '150x150' }, default_url: '/avatar.png'
  validates_attachment_content_type :profile_pic, content_type: /\Aimage\/.*\z/
end
