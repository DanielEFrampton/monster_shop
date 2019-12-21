require "rails_helper"

RSpec.describe 'As a logged in user editing password' do

  describe "When I visit my profile page" do
    it "I see a link to edit my password" do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      click_link "Update Password"

      expect(current_path).to eq('/profile/edit_password')
    end
  end

  describe "When I click the link to update password and fill both fields with same password" do
    it"should update my password and route me to my profile and display flash message" do
      user = create(:user)
      visit '/'

      click_on "Login"

      fill_in :email, with: user.email
      fill_in :password, with: "landlubberssuck"

      click_button "Login"

      click_on "Profile"
      click_on "Update Password"

      fill_in :password, with: "testingpassword"
      fill_in :password_confirmation, with: "testingpassword"
      click_on "Update Info"
      expect(current_path).to eq('/profile')
      expect(page).to have_content("Your password has been updated.")

      click_on "Logout"

      click_on "Login"

      fill_in :email, with: user.email
      fill_in :password, with: "testingpassword"

      click_button "Login"

      expect(current_path).to eq('/profile')
    end
  end

  describe 'when I fail to fill in the same password in both fields' do
    it 'should show flash message and return to form if info is missing' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      
      visit '/profile/edit_password'

      fill_in :password, with: 'newpassword'
      fill_in :password_confirmation, with: ''

      click_on "Update Info"

      expect(current_path).to eq('/profile/edit_password')
      expect(page).to have_content("Scupper that! Ye should fill both fields with the same password!")

      fill_in :password, with: 'newpassword'
      fill_in :password_confirmation, with: 'newpurseword'

      expect(current_path).to eq('/profile/edit_password')
      expect(page).to have_content("Scupper that! Ye should fill both fields with the same password!")
    end
  end
end
