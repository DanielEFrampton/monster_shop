class Coupon < ApplicationRecord
  validates_presence_of :name, :code, :percent_off
  validates_uniqueness_of :name, :code
  validates_inclusion_of :percent_off, in: (0..100)

  belongs_to :merchant
  has_many :orders

  def self.reached_limit
    count >= 5
  end

  def disabled
    !enabled
  end

  def used?
    orders.any?
  end

  def used_by?(user)
    orders.where(user: user).any?
  end

  def enabled_status
    if enabled
      "Enabled"
    else
      "Disabled"
    end
  end
end
