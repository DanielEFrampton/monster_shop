class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :password,
                        :password_confirmation
                        
  has_secure_password

  enum role: %w(default)

  def duplicate_email?
    # Refactor this to be pure ActiveRecord
    User.pluck(:email).include?(email)
  end
end
