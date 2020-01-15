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
    it { should belong_to :merchant }
    it { should have_many :orders }
  end

  describe 'methods' do
    describe 'instance methods' do
      describe 'disabled' do
        it 'returns true if enabled attribute is false, and vice versa' do
          merchant = create(:merchant)
          coupon_1 = Coupon.create!(name: "50%-off Coupon", code: "ABC123", percent_off: 50, merchant: merchant)
          coupon_2 = Coupon.create!(name: "75%-off Coupon", code: "ABC124", percent_off: 75, merchant: merchant, enabled: false)

          expect(coupon_1.disabled).to eq(false)
          expect(coupon_2.disabled).to eq(true)
        end
      end

      describe 'used?' do
        it 'returns true if associated with at least on order or false if not' do
          merchant = create(:merchant)
          coupon_1 = Coupon.create!(name: "50%-off Coupon", code: "ABC123", percent_off: 50, merchant: merchant)
          coupon_2 = Coupon.create!(name: "75%-off Coupon", code: "ABC124", percent_off: 75, merchant: merchant)
          order = create(:order, coupon_id: coupon_2.id)

          expect(coupon_1.used?).to eq(false)
          expect(coupon_2.used?).to eq(true)
        end
      end

      describe 'used_by?' do
        it 'returns true if associated with at least one order by given user' do
          merchant = create(:merchant)
          coupon_1 = Coupon.create!(name: "50%-off Coupon", code: "ABC123", percent_off: 50, merchant: merchant)
          coupon_2 = Coupon.create!(name: "75%-off Coupon", code: "ABC124", percent_off: 75, merchant: merchant)
          order = create(:order, coupon_id: coupon_2.id)
          user_1 = create(:user)
          user_2 = create(:user)

          user_1.orders << order

          expect(coupon_1.used_by?(user_1)).to eq(false)
          expect(coupon_1.used_by?(user_2)).to eq(false)
          expect(coupon_2.used_by?(user_1)).to eq(true)
          expect(coupon_2.used_by?(user_2)).to eq(false)
        end
      end

      describe 'enabled_status' do
        it 'prints enabled status as a string' do
          merchant = create(:merchant)
          coupon_1 = Coupon.create(name: "50%-off Coupon", code: "ABC123", percent_off: 50, merchant: merchant)
          coupon_2 = Coupon.create(name: "75%-off Coupon", code: "ABC124", percent_off: 75, enabled: false, merchant: merchant)

          expect(coupon_1.enabled_status).to eq('Enabled')
          expect(coupon_2.enabled_status).to eq('Disabled')
        end
      end
    end
  end
end
