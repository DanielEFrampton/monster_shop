require "rails_helper"

RSpec.describe 'admin users show page' do
  describe 'as an Admin user' do
    before(:each) do
      @admin_user_1 = create(:user, name: "Admin Pirate", role: 2)
      @default_user_1 = create(:user, name: "Default Pirate", role: 0)
      @fake_user = create(:user, email: 'fake@faketown.com')

      visit '/login'

      fill_in :email, with: @admin_user_1.email
      fill_in :password, with: "landlubberssuck"
      click_button 'Login'
    end

    it "I see a link to edit the password" do

      visit "/admin/users/#{@default_user_1.id}"

      click_on "Update Password"

      expect(current_path).to eq("/admin/users/#{@default_user_1.id}/edit_password")
    end

    it "I should be able to update the password and be routed to the admin user show page with flash message" do

      visit "/admin/users/#{@default_user_1.id}"

      click_on "Update Password"

      fill_in :password, with: "testingpassword"
      fill_in :password_confirmation, with: "testingpassword"

      click_on "Update Info"

      expect(current_path).to eq("/admin/users/#{@default_user_1.id}")
      expect(page).to have_content("The password has been updated.")

      click_link "Logout"

      visit '/login'

      fill_in :email, with: @default_user_1.email
      fill_in :password, with: "testingpassword"

      click_button "Login"

      expect(page).to have_content "Logged in as #{@default_user_1.name}"
    end

    it 'should show flash message and return to form if info is missing' do

      visit "/admin/users/#{@default_user_1.id}/edit_password"

      fill_in :password, with: 'newpassword'
      fill_in :password_confirmation, with: ''

      click_on "Update Info"

      expect(current_path).to eq("/admin/users/#{@default_user_1.id}/edit_password")
      expect(page).to have_content("Scupper that! Ye should fill both fields with the same password!")

      fill_in :password, with: 'newpassword'
      fill_in :password_confirmation, with: 'newpurseword'

      expect(current_path).to eq("/admin/users/#{@default_user_1.id}/edit_password")
      expect(page).to have_content("Scupper that! Ye should fill both fields with the same password!")
    end
  end
end
