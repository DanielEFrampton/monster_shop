require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :code }
    it { should validate_uniqueness_of :code }
    it { should validate_presence_of :percent_off }
    it { should validate_inclusion_of(:percent_off).in_range(0..100) }
  end

  describe 'initalization' do
    before(:each) do
      @coupon = Coupon.new(name: "50%-off Coupon", code: "ABC123", percent_off: 50)
    end

    it "should initialize with provided name, code, and percent off" do
      expect(@coupon.name).to eq("50%-off Coupon")
      expect(@coupon.code).to eq("ABC123")
      expect(@coupon.percent_off).to eq(50)
    end

    it "should initialize with enabled field with default value of true" do
      expect(@coupon.enabled).to eq(true)
    end
  end

  describe 'relationships' do
    # it { should belong_to }
  end

  describe 'methods' do
  end
end
