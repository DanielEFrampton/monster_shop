require 'rails_helper'

RSpec.describe 'As a logged-in merchant user', type: :feature do
  describe 'when I visit the coupons index' do
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

      @coupon_1 = @merchant.coupons.create!(name: "Summer Deal 50%-Off", code: "50OFF", percent_off: 50)
      @coupon_2 = @merchant.coupons.create!(name: "Holiday Weekend 75%-Off", code: "75OFF", percent_off: 75)

      @order = create(:order, coupon: @coupon_2)

      visit '/'
      click_on 'Login'

      fill_in 'Email Address', with: @merchant_user.email
      fill_in 'Password', with: 'merchant'

      click_button 'Login'

      visit '/merchant/coupons'
    end

    describe "and I click on the delete button next to a coupon that's never been used" do
      before(:each) do
        within "#coupon-#{@coupon_1.id}" do
          click_on 'Delete'
        end
      end

      it 'I remain on the coupons index' do
        expect(current_path).to eq('/merchant/coupons')
      end

      it "I see a flash message confirming it was deleted" do
        expect(page).to have_content "Ye sent that blasted coupon into the briny deep! Aye, 'twas deleted."
      end

      it 'and it no longer appears on the coupon index' do
        expect(page).not_to have_css("#coupon-#{@coupon_1.id}")
        expect(page).not_to have_content("#{@coupon_1.id}")
        expect(page).not_to have_content("#{@coupon_1.name}")
        expect(page).not_to have_content("#{@coupon_1.code}")
      end
    end

    describe 'and I click on the delete button next to a used coupon' do
      before(:each) do
        within "#coupon-#{@coupon_2.id}" do
          click_on 'Delete'
        end
      end

      it "I see a flash message saying it couldn't be deleted" do
        expect(page).to have_content("Scupper that! This here coupon been used on an order, ye can't delete it.")
      end

      it "and coupon remains on index" do
        expect(page).to have_css("#coupon-#{@coupon_2.id}")
        expect(page).to have_content("#{@coupon_2.id}")
        expect(page).to have_content("#{@coupon_2.name}")
        expect(page).to have_content("#{@coupon_2.code}")
      end
    end
  end
end
