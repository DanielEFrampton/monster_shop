require 'rails_helper'

RSpec.describe 'As a logged-in merchant user', type: :feature do
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

    visit '/'
    click_on 'Login'

    fill_in 'Email Address', with: @merchant_user.email
    fill_in 'Password', with: 'merchant'

    click_button 'Login'
  end

  describe 'when I visit my dashboard and click "Manage My Coupons"' do
    before(:each) do
      visit '/merchant'

      click_link 'Manage My Coupons'
    end

    it 'I see a link to "Create New Coupon"' do
      expect(page).to have_link('Create New Coupon', href: '/merchant/coupons/new')
    end

    describe 'and I click on the "Create New Coupon" link' do
      before(:each) do
        click_link 'Create New Coupon'
      end

      it 'I see a form with fields for coupon name, code, and percent off (btw. 0.0 - 1.0)' do
        expect(current_path).to eq('/merchant/coupons/new')
        expect(page).to have_field('Name')
        expect(page).to have_field('Code')
        expect(page).to have_field('Percent Off')
      end

      describe "and I fill out each field with valid info and click 'Create Coupon'" do
        before(:each) do
          fill_field 'Name', with: "Summer Deal"
          fill_field 'Code', with: 'SUMMERBLAST'
          fill_field 'Percent Off', with: '50%'

          click_button 'Create Coupon'
        end

        it 'I am returned to my coupons index page and see that coupon listed with all the info I input as well as its ID and enabled status as Enabled' do
          expect(current_path).to be('/merchant/coupons')

          within "#coupon-#{Coupon.last.id}" do
            expect(page).to have_content("#{Coupon.last.id}")
            expect(page).to have_content("Summer Deal")
            expect(page).to have_content("SUMMERBLAST")
            expect(page).to have_content("50%")
            expect(page).to have_content("Enabled")
          end
        end
      end

      describe 'and I fail to fill in all fields' do
        it 'I see an error message and return to the form which shows previously entered data' do
          fill_field 'Name', with: "Summer Deal"
          # Code field empty
          fill_field 'Percent Off', with: '50%'

          click_button 'Create Coupon'

          expect(page).to have_content("Code field cannot be empty")
          expect(current_path).to eq("/merchant/coupons/new")
          expect(page.find_field('Name')).to eq("Summer Deal")
          expect(page.find_field('Percent Off')).to eq("50%")

          fill_field 'Name', with: ''
          fill_field 'Code', with: 'ACODE'

          click_button 'Create Coupon'

          expect(page).to have_content("Name field cannot be empty")
          expect(current_path).to eq("/merchant/coupons/new")
          expect(page.find_field('Name')).to eq('')
          expect(page.find_field('Code')).to eq('ACODE')
          expect(page.find_field('Percent Off')).to eq("50%")
        end
      end

      describe 'and I enter a name or code that already exists in the db' do
        it 'I see an error message and return to the form which shows previously entered data' do
          fill_field 'Name', with: @coupon_1.name
          fill_field 'Code', with: 'SUMMERBLAST'
          fill_field 'Percent Off', with: '50%'

          click_button 'Create Coupon'

          expect(page).to have_content("Name already exists in database")
          expect(current_path).to eq("/merchant/coupons/new")
          expect(page.find_field('Name')).to eq(@coupon_1.name)
          expect(page.find_field('Code')).to eq('SUMMERBLAST')
          expect(page.find_field('Percent Off')).to eq("50%")

          fill_field 'Name', with: 'Unique Name'
          fill_field 'Code', with: @coupon_1.code

          click_button 'Create Coupon'

          expect(page).to have_content("Code already exists in database")
          expect(current_path).to eq("/merchant/coupons/new")
          expect(page.find_field('Name')).to eq('Unique Name')
          expect(page.find_field('Code')).to eq(@coupon_1.code)
          expect(page.find_field('Percent Off')).to eq("50%")
        end
      end

      describe 'and I enter a percent off value outside of 0-100' do
        before(:each) do
          fill_field 'Name', with: "Summer Deal"
          fill_field 'Code', with: 'SUMMERBLAST'
          fill_field 'Percent Off', with: '50%'

          click_button 'Create Coupon'
        end

        it 'I see an error message and return to the form which shows previously entered data' do
          expect(page).to have_content("Percent Off must be in range 0-100%")
          expect(current_path).to eq("/merchant/coupons/new")
          expect(page.find_field('Name')).to eq('Summer Deal')
          expect(page.find_field('Code')).to eq('SUMMERBLAST')
          expect(page.find_field('Percent Off')).to eq("50%")
        end
      end
    end
  end
end
