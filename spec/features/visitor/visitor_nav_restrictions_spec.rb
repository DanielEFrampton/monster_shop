require 'rails_helper'

RSpec.describe "As a visitor" do
  describe "i get a 404 error", type: :feature do
    it "when i visit default or merchant or admin dashboards" do
      visit '/profile'
      expect(page).to have_content("404")

      visit '/merchant'
      expect(page).to have_content("404")

      visit '/admin'
      expect(page).to have_content("404")

    end
  end
end
