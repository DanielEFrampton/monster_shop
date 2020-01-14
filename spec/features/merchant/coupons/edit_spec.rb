require 'rails_helper'

RSpec.describe 'As a logged-in Merchant user', type: :feature do
  describe 'when I visit "Manage My Coupons" and I have coupons' do
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

      visit '/merchant/coupons'
    end

    it 'I should see an "Edit" button for each coupon' do
      within "#coupon-#{@coupon_1.id}" do
        expect(page).to have_button('Edit')
      end

      within "#coupon-#{@coupon_2.id}" do
        expect(page).to have_button('Edit')
      end
    end

    describe 'and I click the "Edit" button next to one of my coupons' do
      before(:each) do
        within "#coupon-#{@coupon_1.id}" do
          click_button('Edit')
        end
      end

      it 'I am taken to a form to edit that coupon' do
        expect(current_path).to eq("/merchant/coupons/#{@coupon_1.id}/edit")
      end

      it 'I see fields for name, code, and percent off with existing values' do
        expect(page).to have_content("Edit Coupon")
        expect(page).to have_field('Name', with: @coupon_1.name)
        expect(page).to have_field('Code', with: @coupon_1.code)
        expect(page).to have_field('Percent Off', with: '50%')
      end

      describe 'and I enter new or changed valid values and click "Update Coupon"' do
        before(:each) do
          fill_in 'Name', with: 'Changed Coupon Name'
          click_on 'Update Coupon'
        end

        it 'I am returned to my coupons index page and see the changed info' do
          within "#coupon-#{@coupon_1.id}" do
            expect(page).to have_content('Changed Coupon Name')
            expect(page).not_to have_content('Summer Deal 50%-Off')
          end
        end
      end

      describe 'and I fail to fill in all fields' do
        it 'I see an error message and return to the form which shows previously entered data' do
          fill_in 'Code', with: ""

          click_button 'Update Coupon'

          expect(page).to have_content("Code can't be blank")
          expect(page).to have_css('h1', text: 'Edit Coupon')
          expect(page.find_field('Name').value).to eq(@coupon_1.name)
          expect(page.find_field('Code').value).to eq("")
          expect(page.find_field('Percent Off').value).to eq("50%")

          fill_in 'Name', with: ''
          fill_in 'Code', with: 'ANEWCODE'

          click_button 'Update Coupon'

          expect(page).to have_content("Name can't be blank")
          expect(page).to have_css('h1', text: 'Edit Coupon')
          expect(page.find_field('Name').value).to eq('')
          expect(page.find_field('Code').value).to eq('ANEWCODE')
          expect(page.find_field('Percent Off').value).to eq("50%")
        end
      end

      describe 'and I enter a name or code that already exists in the db' do
        it 'I see an error message and return to the form which shows previously entered data' do
          fill_in 'Name', with: @coupon_2.name

          click_button 'Update Coupon'

          expect(page).to have_content("Name has already been taken")
          expect(page.find('h1').text).to eq('Edit Coupon')
          expect(page.find_field('Name').value).to eq(@coupon_2.name)
          expect(page.find_field('Code').value).to eq(@coupon_1.code)
          expect(page.find_field('Percent Off').value).to eq('50%')

          fill_in 'Name', with: 'Unique Name'
          fill_in 'Code', with: @coupon_2.code

          click_button 'Update Coupon'

          expect(page).to have_content("Code has already been taken")
          expect(page.find('h1').text).to eq('Edit Coupon')
          expect(page.find_field('Name').value).to eq('Unique Name')
          expect(page.find_field('Code').value).to eq(@coupon_2.code)
          expect(page.find_field('Percent Off').value).to eq("50%")
        end
      end

      describe 'and I enter a percent off value outside of 0-100' do
        before(:each) do
          fill_in 'Percent Off', with: '110%'

          click_button 'Update Coupon'
        end

        it 'I see an error message and return to the form which shows previously entered data' do
          expect(page).to have_content("Percent off must be within range 0-100%")
          expect(page.find('h1').text).to eq('Edit Coupon')
          expect(page.find_field('Name').value).to eq(@coupon_1.name)
          expect(page.find_field('Code').value).to eq(@coupon_1.code)
          expect(page.find_field('Percent Off').value).to eq("110%")
        end
      end
    end
  end
end
