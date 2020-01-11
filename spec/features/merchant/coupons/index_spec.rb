require 'rails_helper'

RSpec.describe 'As a merchant user', type: :feature do
  before(:each) do
    @merchant = Merchant.create(name: "Pegleg's Pirate Supply", address: '763 Blazing Way', city: 'Ember', state: 'Volcano Island', zip: 80210)

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

    @coupon_1 = @merchant.coupons.create!(name: "Summer Deal 50%-Off", code: "50OFF", percent_off: 0.50)
    @coupon_2 = @merchant.coupons.create!(name: "Holiday Weekend 75%-Off", code: "75OFF", percent_off: 0.75)

    visit '/'
    click_on 'Login'

    fill_in 'Email Address', with: @merchant_user.email
    fill_in 'Password', with: 'merchant'

    click_button 'Login'
  end

  describe "when I visit my coupons index view" do
    before(:each) do
      visit '/merchant'

      click_on 'Manage My Coupons'
    end

    it 'I see the id, name, code, percentage off, and enabled status of all my coupons' do
      within "#coupon-#{@coupon_1.id}" do
        expect(page).to have_link("#{@coupon_1.id}", href: "/merchant/coupons/#{@coupon_1.id}")
        expect(page).to have_link("#{@coupon_1.name}", href: "/merchant/coupons/#{@coupon_1.id}")
        expect(page).to have_content("#{@coupon_1.code}")
        expect(page).to have_content("#{@coupon_1.percent_off}")
        expect(page).to have_content("#{@coupon_1.enabled_status}")
      end

      within "#coupon-#{@coupon_2.id}" do
        expect(page).to have_link("#{@coupon_2.id}", href: "/merchant/coupons/#{@coupon_2.id}")
        expect(page).to have_link("#{@coupon_2.name}", href: "/merchant/coupons/#{@coupon_2.id}")
        expect(page).to have_content("#{@coupon_2.code}")
        expect(page).to have_content("#{@coupon_2.percent_off}")
        expect(page).to have_content("#{@coupon_2.enabled_status}")
      end
    end

    it "the id and name are both links to that coupon's show page" do
    end

    it "I see a button next to each coupon to delete that coupon" do
    end

    it "I see a button to enable or disable the coupon depending on its status" do
    end
  end
end
