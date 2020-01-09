require 'rails_helper'

RSpec.describe 'admin users show page' do
  describe 'as an Admin user' do
    before(:each) do
      @admin_user_1 = create(:user, role: 2)
      @default_user_1 = create(:user, role: 0)
      @default_user_2 = create(:user, role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user_1)
    end

    it 'I can see all info a user can see except edit button' do
      visit "/admin/users/#{@default_user_1.id}"

      expect(page).to have_content(@default_user_1.name)
      expect(page).to have_content(@default_user_1.address)
      expect(page).to have_content(@default_user_1.city)
      expect(page).to have_content(@default_user_1.state)
      expect(page).to have_content(@default_user_1.zip)
      expect(page).to have_content(@default_user_1.email)

      # expect(page).to_not have_link("Update Profile")
      # expect(page).to_not have_link("Update Password")

      visit "/admin/users/#{@default_user_2.id}"

      expect(page).to have_content(@default_user_2.name)
      expect(page).to have_content(@default_user_2.address)
      expect(page).to have_content(@default_user_2.city)
      expect(page).to have_content(@default_user_2.state)
      expect(page).to have_content(@default_user_2.zip)
      expect(page).to have_content(@default_user_2.email)

      # expect(page).to_not have_link("Update Profile")
      # expect(page).to_not have_link("Update Password")
    end
  end
end
