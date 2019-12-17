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

  enum role: %w(default merchant admin)
end
