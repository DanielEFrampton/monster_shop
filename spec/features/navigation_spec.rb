
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within '.topnav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within '.topnav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within '.topnav' do
        click_link 'Treasure Trove'
      end

      expect(current_path).to eq("/")

      within '.topnav' do
        expect(page).to have_link('Login')
      end

      within '.topnav' do
        expect(page).to have_link('Register')
      end

    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within '.topnav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within '.topnav' do
        expect(page).to have_content("Cart: 0")
      end

    end
  end
end
