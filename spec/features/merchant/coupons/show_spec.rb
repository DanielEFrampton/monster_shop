require 'rails_helper'

RSpec.describe 'As a logged-in merchant user', type: :feature do
  before(:each) do
    @merchant = Merchant.create(name: "Pegleg's Pirate Supply",
                                address: '763 Blazing Way',
                                city: 'Ember',
                                state: 'Volcano Island',
                                zip: 80210)
    @merchant_user = User.create(name: "Admiral Redbeard",
                                address: "123 Ocean Breeze",
                                city: "Bootytown",
                                state: "Turks & Caicos",
                                zip: "13375",
                                email: 'merchant@treasuretrove.com',
                                password: "merchant",
                                password_confirmation: "merchant",
                                merchant_id: @merchant.id,
                                role: 1)
    @coupon_1 = @merchant.coupons.create!(name: "Summer Deal 50%-Off",
                                          code: "50OFF",
                                          percent_off: 50)
    @coupon_2 = @merchant.coupons.create!(name: "Holiday Weekend 75%-Off",
                                          code: "75OFF",
                                          percent_off: 75,
                                          enabled: false)

    visit '/'
    click_on 'Login'

    fill_in 'Email Address', with: @merchant_user.email
    fill_in 'Password', with: 'merchant'

    click_button 'Login'
  end

  describe 'when I visit my coupons index' do
    before(:each) do
      visit '/merchant/coupons'
    end

    it "I see that all coupon's names or IDs are links to their show pages" do
      expect(page).to have_link("#{@coupon_1.id}",
                                href: "/merchant/coupons/#{@coupon_1.id}")
      expect(page).to have_link("#{@coupon_1.name}",
                                href: "/merchant/coupons/#{@coupon_1.id}")
      expect(page).to have_link("#{@coupon_2.id}",
                                href: "/merchant/coupons/#{@coupon_2.id}")
      expect(page).to have_link("#{@coupon_2.name}",
                                href: "/merchant/coupons/#{@coupon_2.id}")
    end

    describe 'when I click the ID or name of a coupon on coupons index' do
      before(:each) do
        click_on @coupon_1.name
      end

      it 'my current path is "/merchant/coupons/:id"' do
        expect(current_path).to eq("/merchant/coupons/#{@coupon_1.id}")
      end

      it "I see that coupon's id, name, code, and percent_off" do
        expect(page).to have_content("Coupon Details")
        expect(page).to have_content("ID: #{@coupon_1.id}")
        expect(page).to have_content("Name: #{@coupon_1.name}")
        expect(page).to have_content("Code: #{@coupon_1.code}")
        expect(page).to have_content("Status: #{@coupon_1.enabled_status}")
        expect(page).to have_content("Percent Off: -#{@coupon_1.percent_off}%")
        expect(page).to have_content("Created: #{@coupon_1.created_at}")
        expect(page).to have_content("Last Updated: #{@coupon_1.updated_at}")
      end
    end
  end
end
