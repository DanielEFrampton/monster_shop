require 'rails_helper'

RSpec.describe 'admin user index page' do
  before(:each) do
    @admin_user_1 = create(:user, role: 2)
    @admin_user_2 = create(:user, role: 2)

    @merchant_user_1 = create(:user, role: 1)
    @merchant_user_2 = create(:user, role: 1)

    @default_user_1 = create(:user, role: 0)
    @default_user_2 = create(:user, role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user_1)
  end

  it 'I see all users in the system with created date and role' do
    visit '/admin/users'

    expect(page).to have_link(@admin_user_1.name)
    expect(page).to have_link(@admin_user_2.name)
    expect(page).to have_link(@merchant_user_1.name)
    expect(page).to have_link(@merchant_user_2.name)
    expect(page).to have_link(@default_user_1.name)
    expect(page).to have_link(@default_user_2.name)

    within "#user-#{@admin_user_2.id}" do
      expect(page).to have_link(@admin_user_2.name)
      expect(page).to have_content(@admin_user_2.email)
      expect(page).to have_content(@admin_user_2.created_date)
      expect(page).to have_content('Admin')
      click_link(@admin_user_2.name)
    end

    expect(current_path).to eq("/admin/users/#{@admin_user_2.id}")

    visit '/admin/users'

    within "#user-#{@merchant_user_1.id}" do
      expect(page).to have_link(@merchant_user_1.name)
      expect(page).to have_content(@merchant_user_1.email)
      expect(page).to have_content(@merchant_user_1.created_date)
      expect(page).to have_content('Merchant')
      click_link(@merchant_user_1.name)
    end

    expect(current_path).to eq("/admin/users/#{@merchant_user_1.id}")

    visit '/admin/users'

    within "#user-#{@default_user_1.id}" do
      expect(page).to have_link(@default_user_1.name)
      expect(page).to have_content(@default_user_1.email)
      expect(page).to have_content(@default_user_1.created_date)
      expect(page).to have_content('Default')
      click_link(@default_user_1.name)
    end

    expect(current_path).to eq("/admin/users/#{@default_user_1.id}")
  end
end
