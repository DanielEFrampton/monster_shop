class Coupon < ApplicationRecord
  validates_presence_of :name, :code, :percent_off
  validates_uniqueness_of :name, :code
  validates_inclusion_of :percent_off, in: (0..100)

  belongs_to :merchant
  has_many :orders

  def used?
    orders.any?
  end

  def enabled_status
    if enabled
      "Enabled"
    else
      "Disabled"
    end
  end
end
