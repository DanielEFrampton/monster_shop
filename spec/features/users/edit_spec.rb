require 'rails_helper'

RSpec.describe 'As a user editing my profile', type: :feature do

  it 'Should update user information' do
      default_user = User.create!(name: "Pirate Jack",
                                 address: "123 Ocean Breeze",
                                    city: "Bootytown",
                                    state: "Turks & Caicos",
                                    zip: "13375",
                                    email: "pirate@thecarribean.com",
                                    password: "landlubberssuck",
                                    password_confirmation: "landlubberssuck",
                                    role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

      visit '/profile'

      expect(page).to_not have_content("7 Seas Drive")
      expect(page).to_not have_content("Port Saint Kitts")
      expect(page).to_not have_content("Arrrkansas")
      expect(page).to_not have_content("13376")

      click_link "Update Profile"

      expect(current_path).to eq('/profile/edit')
      expect(page).to have_content("Update Your Profile Information")

      fill_in :address, with: "7 Seas Drive"
      fill_in :city, with: "Port Saint Kitts"
      fill_in :state, with: "Arrrkansas"
      fill_in :zip, with: "13376"

      click_on "Update Info"

      expect(current_path).to eq("/profile")

      expect(page).to have_content("Your information has been updated.")
      expect(page).to have_content(default_user.name)
      expect(page).to have_content("7 Seas Drive")
      expect(page).to have_content("Port Saint Kitts")
      expect(page).to have_content("Arrrkansas")
      expect(page).to have_content("13376")
      expect(page).to have_content(default_user.email)

      expect(page).to_not have_content("123 Ocean Breeze")
      expect(page).to_not have_content("Bootytown")
      expect(page).to_not have_content("Turks & Caicos")
      expect(page).to_not have_content("13375")
    end

end
