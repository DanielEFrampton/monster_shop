class Coupon < ApplicationRecord
  validates_presence_of :name, :code, :percent_off
  validates_uniqueness_of :name, :code
  validates_inclusion_of :percent_off, in: (0.0..1.0)

  belongs_to :merchant
end
