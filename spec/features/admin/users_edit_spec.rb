require 'rails_helper'

RSpec.describe 'admin users show page' do
  describe 'as an Admin user' do
    before(:each) do
      @admin_user_1 = create(:user, role: 2)
      @default_user_1 = create(:user, role: 0)
      @fake_user = create(:user, email: 'fake@faketown.com')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user_1)
    end

    it 'I can update user profile information' do

      visit "/admin/users/#{@default_user_1.id}"

      expect(page).to have_link("Update Profile")

      click_link("Update Profile")

      expect(current_path).to eq("/admin/users/#{@default_user_1.id}/edit")
      expect(page).to have_content("Update Profile Information")

      fill_in :user_address, with: "7 Seas Drive"
      fill_in :user_city, with: "Port Saint Kitts"
      fill_in :user_state, with: "Arrrkansas"
      fill_in :user_zip, with: "13376"

      click_on "Update Info"

      expect(current_path).to eq("/admin/users/#{@default_user_1.id}")

      expect(page).to have_content("Your information has been updated.")
      expect(page).to have_content(@default_user_1.name)
      expect(page).to have_content("7 Seas Drive")
      expect(page).to have_content("Port Saint Kitts")
      expect(page).to have_content("Arrrkansas")
      expect(page).to have_content("13376")
      expect(page).to have_content(@default_user_1.email)

      expect(page).to_not have_content("123 Ocean Breeze")
      expect(page).to_not have_content("Bootytown")
      expect(page).to_not have_content("Turks & Caicos")
      expect(page).to_not have_content("13375")
    end

    it 'should show flash message and return to form if info is missing' do

      visit "/admin/users/#{@default_user_1.id}/edit"

      fill_in :user_address, with: "7 Seas Drive"
      fill_in :user_city, with: "Port Saint Kitts"
      fill_in :user_state, with: "Arrrkansas"
      fill_in :user_zip, with: ""

      click_on "Update Info"

      expect(current_path).to eq("/admin/users/#{@default_user_1.id}/edit")
      expect(page).to have_content("Scupper that! Ye be missing required fields!")
    end

    it 'should show flash message and return to form if new email already exists' do

      visit "/admin/users/#{@default_user_1.id}/edit"

      fill_in :user_email, with: 'fake@faketown.com'

      click_on "Update Info"

      expect(current_path).to eq("/admin/users/#{@default_user_1.id}/edit")
      expect(page).to have_content("Scupper that! That email do be in use by another scallywag!")
    end
  end
end
