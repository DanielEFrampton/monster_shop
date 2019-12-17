require 'rails_helper'

RSpec.describe 'As a visitor', type: :feature do
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
  end

  describe 'When I visit the login path' do
    it 'I see a field to enter my email address and password' do
      visit '/login'

      expect(page).to have_field('Email Address')
      expect(page).to have_field('Password')
    end
  end

  describe 'When I submit valid information' do
    it 'If I am a regular user, I am redirected to my profile page and I see a flash message that I am logged in' do
      visit '/login'

      fill_in :email, with: @default_user.email
      fill_in :password, with: "landlubberssuck"

      click_on "Login"

      expect(current_path).to eq('/profile')
    end

    it 'If I am a merchant user, I am redirected to my merchant dashboard page and I see a flash message that I am logged in' do
      visit '/login'

      fill_in :email, with: @merchant_user.email
      fill_in :password, with: "landlubberssuck"

      click_on "Login"

      expect(current_path).to eq('/merchant')
    end

    it 'If I am an admin user, I am redirected to my admin dashboard page and I see a flash message that I am logged in' do
      visit '/login'

      fill_in :email, with: @admin_user.email
      fill_in :password, with: "landlubberssuck"

      click_on "Login"

      expect(current_path).to eq('/admin')
    end
  end

  describe 'when I submit invalid information' do
    it 'Then I am redirected to the login page and see non-specific flash message that credentials were incorrect' do
      visit '/login'

      fill_in :email, with: @default_user.email
      fill_in :password, with: "landflubbersduck"

      click_on 'Login'

      expect(current_path).to eq('/login')
      expect(page).to have_content('Avast! Thar be problems with the credentials ye input!')

      fill_in :email, with: "pirat@thecarriboan.com"
      fill_in :password, with: "landlubberssuck"

      click_on 'Login'

      expect(current_path).to eq('/login')
      expect(page).to have_content('Avast! Thar be problems with the credentials ye input!')
    end
  end

  describe 'if I am a logged-in user, merchant, or admin and visit the login path' do
    it 'If I am a regular user, I am redirected to my profile page and I see a flash message that tells me I am already logged in' do
      visit '/login'

      fill_in :email, with: @default_user.email
      fill_in :password, with: "landlubberssuck"

      click_on 'Login'

      visit '/login'

      expect(current_path).to eq('/profile')
      expect(page).to have_content("Arr. Ye be already logged in.")
    end
    it 'If I am a merchant user, I am redirected to my merchant dashboard page and I see a flash message that tells me I am already logged in' do
      visit '/login'

      fill_in :email, with: @merchant_user.email
      fill_in :password, with: "landlubberssuck"

      click_on 'Login'

      visit '/login'

      expect(current_path).to eq('/merchant')
      expect(page).to have_content("Arr. Ye be already logged in.")
    end
    it 'If I am an admin user, I am redirected to my admin dashboard page and I see a flash message that tells me I am already logged in' do
      visit '/login'

      fill_in :email, with: @admin_user.email
      fill_in :password, with: "landlubberssuck"

      click_on 'Login'

      visit '/login'

      expect(current_path).to eq('/admin')
      expect(page).to have_content("Arr. Ye be already logged in.")
    end
  end
end
