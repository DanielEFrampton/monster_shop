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

    @coupon_1 = @merchant.coupons.create!(name: "Summer Deal 50%-Off", code: "50OFF", percent_off: 50)
    @coupon_2 = @merchant.coupons.create!(name: "Holiday Weekend 75%-Off", code: "75OFF", percent_off: 75, enabled: false)

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
        expect(page).to have_content("#{@coupon_1.percent_off}%")
        expect(page).to have_content("#{@coupon_1.enabled_status}")
      end

      within "#coupon-#{@coupon_2.id}" do
        expect(page).to have_link("#{@coupon_2.id}", href: "/merchant/coupons/#{@coupon_2.id}")
        expect(page).to have_link("#{@coupon_2.name}", href: "/merchant/coupons/#{@coupon_2.id}")
        expect(page).to have_content("#{@coupon_2.code}")
        expect(page).to have_content("#{@coupon_2.percent_off}%")
        expect(page).to have_content("#{@coupon_2.enabled_status}")
      end
    end

    it "the id and name are both links to that coupon's show page" do
      within "#coupon-#{@coupon_1.id}" do
        expect(page).to have_link("#{@coupon_1.id}", href: "/merchant/coupons/#{@coupon_1.id}")
        expect(page).to have_link("#{@coupon_1.name}", href: "/merchant/coupons/#{@coupon_1.id}")
      end

      within "#coupon-#{@coupon_2.id}" do
        expect(page).to have_link("#{@coupon_2.id}", href: "/merchant/coupons/#{@coupon_2.id}")
        expect(page).to have_link("#{@coupon_2.name}", href: "/merchant/coupons/#{@coupon_2.id}")
      end
    end

    it "I see a button next to each coupon to delete that coupon" do
      within "#coupon-#{@coupon_1.id}" do
        expect(page).to have_button('Delete')
      end

      within "#coupon-#{@coupon_2.id}" do
        expect(page).to have_button('Delete')
      end
    end

    it "I see a button to enable or disable the coupon depending on its status" do
      within "#coupon-#{@coupon_1.id}" do
        expect(page).to have_button('Disable')
      end

      within "#coupon-#{@coupon_2.id}" do
        expect(page).to have_button('Enable')
      end
    end

    describe 'if I click disable next to an enabled coupon' do
      before(:each) do
        within "#coupon-#{@coupon_1.id}" do
          click_on 'Disable'
        end
      end

      it 'I am returned to the coupon index' do
        expect(current_path).to eq('/merchant/coupons')
      end

      it 'I see a flash message' do
        expect(page).to have_content("Yarr, ye keelhauled the coupon. It do be disabled.")
      end

      it 'I see the enabled status has changed to Disabled' do
        within "#coupon-#{@coupon_1.id}" do
          expect(page).to have_content('Disabled')
        end
      end

      it 'I see the Disable button has been replaced with an Enable button' do
        within "#coupon-#{@coupon_1.id}" do
          expect(page).to have_button('Enable')
          expect(page).not_to have_button('Disable')
        end
      end
    end

    describe 'if I click enable next to a disabled coupon' do
      before(:each) do
        within "#coupon-#{@coupon_2.id}" do
          click_on 'Enable'
        end
      end

      it 'I am returned to the coupon index' do
        expect(current_path).to eq('/merchant/coupons')
      end

      it 'I see a flash message' do
        expect(page).to have_content("The coupon rises from the depths like a monstrous kraken! That is, it's enabled.")
      end

      it 'I see the enabled status has changed to Enabled' do
        within "#coupon-#{@coupon_2.id}" do
          expect(page).to have_content('Enabled')
        end
      end

      it 'I see the Enable button has been replaced with a Disable button' do
        within "#coupon-#{@coupon_2.id}" do
          expect(page).to have_button('Disable')
          expect(page).not_to have_button('Enable')
        end
      end
    end
  end
end
