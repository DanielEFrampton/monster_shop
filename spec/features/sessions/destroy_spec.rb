require 'rails_helper'

RSpec.describe 'As a registered user, merchant, or admin', type: :feature do
  before(:each) do
    @default_user = User.create!(name: "Dread Pirate Jack",
                                address: "123 Ocean Breeze",
                                city: "Bootytown",
                                state: "Turks & Caicos",
                                zip: "13375",
                                email: "pirate@thecarribean.com",
                                password: "landlubberssuck",
                                password_confirmation: "landlubberssuck",
                                role: 0)

    @merchant_user = User.create!(name: "Entrepreneurial Pirate Jack",
                                address: "123 Ocean Breeze",
                                city: "Bootytown",
                                state: "Turks & Caicos",
                                zip: "13375",
                                email: "richpirate@thecarribean.com",
                                password: "landlubberssuck",
                                password_confirmation: "landlubberssuck",
                                role: 1)

    @admin_user = User.create!(name: "Middle-Management Pirate Jack",
                              address: "123 Ocean Breeze",
                              city: "Bootytown",
                              state: "Turks & Caicos",
                              zip: "13375",
                              email: "bossypirate@thecarribean.com",
                              password: "landlubberssuck",
                              password_confirmation: "landlubberssuck",
                              role: 2)
    @dapper_dans = Merchant.create(name: "Dapper Dan's Pirate Polish", address: '123 Dandy Rd.', city: 'Barbados', state: 'CO', zip: 80203)
    @grease = @dapper_dans.items.create(name: "Dapper Dan's Hair Grease", description: "Great for the authentic pirate sheen!", price: 20, image: "http://dapperdanpomade.net/wp-content/uploads/2015/01/Dapper-Dan-Pomade.gif", inventory: 25)
    @pomade = @dapper_dans.items.create(name: "Dapper Dan's Parrot Pomade", description: "For the discerning pirate who likes one's companion to coordinate!", price: 2, image: "http://www.vintageijas.com/WebRoot/vilkas04/Shops/20131002-11092-259044-1/5432/F652/AF68/FF6C/36FE/0A28/100B/6DD3/IMG_4101.JPG", inventory: 100)
  end

  describe 'When I visit the logout path' do
    it "I am redirected to the home page of the site, see flash message indicating log out, and cart items are deleted" do
      visit "/items/#{@grease.id}"
      click_on "Add To Cart"
      visit "/items/#{@pomade.id}"
      click_on "Add To Cart"

      expect(page).to have_content("Cart: 2")

      visit '/login'

      fill_in :email, with: @default_user.email
      fill_in :password, with: "landlubberssuck"

      click_button 'Login'

      click_on 'Logout'

      expect(current_path).to eq('/')
      expect(page).to have_content('Ye done walked the plank! Er, that is, ye logged out.')
      expect(page).to have_content("Cart: 0")

      visit "/items/#{@grease.id}"
      click_on "Add To Cart"
      visit "/items/#{@pomade.id}"
      click_on "Add To Cart"

      expect(page).to have_content("Cart: 2")

      visit '/login'

      fill_in :email, with: @merchant_user.email
      fill_in :password, with: "landlubberssuck"

      click_button 'Login'

      click_on 'Logout'

      expect(current_path).to eq('/')
      expect(page).to have_content('Ye done walked the plank! Er, that is, ye logged out.')
      expect(page).to have_content("Cart: 0")

      visit "/items/#{@grease.id}"
      click_on "Add To Cart"
      visit "/items/#{@pomade.id}"
      click_on "Add To Cart"

      expect(page).to have_content("Cart: 2")

      visit '/login'

      fill_in :email, with: @admin_user.email
      fill_in :password, with: "landlubberssuck"

      click_button 'Login'

      click_on 'Logout'

      expect(current_path).to eq('/')
      expect(page).to have_content('Ye done walked the plank! Er, that is, ye logged out.')
      expect(page).to have_content("Cart: 0")
    end
  end
end
