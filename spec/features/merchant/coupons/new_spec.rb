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
    visit '/'
    click_on 'Login'

    fill_in 'Email Address', with: @merchant_user.email
    fill_in 'Password', with: 'merchant'

    click_button 'Login'
  end

  describe 'and I click "Manage My Coupons with less than five coupons' do
    before(:each) do
      @coupon_1 = @merchant.coupons.create!(name: "Summer Deal 50%-Off", code: "50OFF", percent_off: 50)
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
          fill_in 'Name', with: "Summer Deal"
          fill_in 'Code', with: 'SUMMERBLAST'
          fill_in 'Percent Off', with: '50%'

          click_button 'Create Coupon'
        end

        it 'I am returned to my coupons index page and see that coupon listed with all the info I input as well as its ID and enabled status as Enabled' do
          expect(current_path).to eq('/merchant/coupons')

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
          fill_in 'Name', with: "Summer Deal"
          fill_in 'Percent Off', with: '50%'

          click_button 'Create Coupon'

          expect(page).to have_content("Code can't be blank")
          expect(page).to have_css('h1', text: 'Create New Coupon')
          expect(page.find_field('Name').value).to eq("Summer Deal")
          expect(page.find_field('Percent Off').value).to eq("50%")

          fill_in 'Name', with: ''
          fill_in 'Code', with: 'ACODE'

          click_button 'Create Coupon'

          expect(page).to have_content("Name can't be blank")
          expect(page).to have_css('h1', text: 'Create New Coupon')
          expect(page.find_field('Name').value).to eq('')
          expect(page.find_field('Code').value).to eq('ACODE')
          expect(page.find_field('Percent Off').value).to eq("50%")
        end
      end

      describe 'and I enter a name or code that already exists in the db' do
        it 'I see an error message and return to the form which shows previously entered data' do
          fill_in 'Name', with: @coupon_1.name
          fill_in 'Code', with: 'SUMMERBLAST'
          fill_in 'Percent Off', with: '50%'

          click_button 'Create Coupon'

          expect(page).to have_content("Name has already been taken")
          expect(page.find('h1').text).to eq('Create New Coupon')
          expect(page.find_field('Name').value).to eq(@coupon_1.name)
          expect(page.find_field('Code').value).to eq('SUMMERBLAST')
          expect(page.find_field('Percent Off').value).to eq("50%")

          fill_in 'Name', with: 'Unique Name'
          fill_in 'Code', with: @coupon_1.code

          click_button 'Create Coupon'

          expect(page).to have_content("Code has already been taken")
          expect(page.find('h1').text).to eq('Create New Coupon')
          expect(page.find_field('Name').value).to eq('Unique Name')
          expect(page.find_field('Code').value).to eq(@coupon_1.code)
          expect(page.find_field('Percent Off').value).to eq("50%")
        end
      end

      describe 'and I enter a percent off value outside of 0-100' do
        before(:each) do
          fill_in 'Name', with: "Summer Deal"
          fill_in 'Code', with: 'SUMMERBLAST'
          fill_in 'Percent Off', with: '110%'

          click_button 'Create Coupon'
        end

        it 'I see an error message and return to the form which shows previously entered data' do
          expect(page).to have_content("Percent off must be within range 0-100%")
          expect(page.find('h1').text).to eq('Create New Coupon')
          expect(page.find_field('Name').value).to eq('Summer Deal')
          expect(page.find_field('Code').value).to eq('SUMMERBLAST')
          expect(page.find_field('Percent Off').value).to eq("110%")
        end
      end
    end
  end

  describe 'and I click "Manage My Coupons" while I have five coupons' do
    before(:each) do
      @coupon_5 = Coupon.create!(name: "50%-off Coupon", code: "ABC123", percent_off: 50, merchant: @merchant)
      @coupon_6 = Coupon.create!(name: "75%-off Coupon", code: "ABC124", percent_off: 75, merchant: @merchant, enabled: false)
      @coupon_7 = Coupon.create!(name: "25%-off Coupon", code: "ABC125", percent_off: 25, merchant: @merchant)
      @coupon_8 = Coupon.create!(name: "40%-off Coupon", code: "ABC126", percent_off: 40, merchant: @merchant, enabled: false)
      @coupon_9 = Coupon.create!(name: "10%-off Coupon", code: "ABC127", percent_off: 10, merchant: @merchant)
      click_on 'Manage My Coupons'
    end

    it 'I do not see a link to create a new coupon' do
      expect(page).not_to have_link('Create New Coupon')
    end

    it 'I see a notification that I must delete coupons before making more' do
      expect(page).to have_content("You have reached the maximum # of coupons and cannot create more until some are deleted.")
    end

    describe 'and I delete one of my coupons' do
      before(:each) do
        within "#coupon-#{@coupon_5.id}" do
          click_on 'Delete'
        end
      end

      it 'I again see a link to create a new coupon and message goes away' do
        expect(page).to have_link('Create New Coupon')
        expect(page).not_to have_content("You have reached the maximum # of coupons and cannot create more until some are deleted.")
      end
    end
  end
end
