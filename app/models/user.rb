class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :password_digest

  has_many :orders
  belongs_to :merchant, optional: true
  has_secure_password
  enum role: %w(default merchant admin)

  def duplicate_email?
    # Refactor this to be pure ActiveRecord
    User.pluck(:email).include?(email)
  end

  def created_date
    created_at.strftime('%B %d, %Y')
  end
end
