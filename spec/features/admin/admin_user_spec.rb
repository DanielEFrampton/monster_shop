
require "rails_helper"

RSpec.describe "a admin user" do
  it "can see the same links as a merchant plus a link to users and dont see cart" do
    admin_user = User.create(name: "Pirate Jack",
                               address: "123 Ocean Breeze",
                                  city: "Bootytown",
                                  state: "Turks & Caicos",
                                  zip: "13375",
                                  email: "pirate@thecarribean.com",
                                  password: "landlubberssuck",
                                  role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

    visit "/"

    within 'nav' do
      expect(page).to have_link("Profile")
      expect(page).to have_link("Logout")
      expect(page).to have_link("Dashboard")
      expect(page).to have_link("Users")

      expect(page).to_not have_link("Login")
      expect(page).to_not have_link("Register")
      expect(page).to_not have_link("Cart")
    end

    expect(page).to have_content("Logged in as #{admin_user.name}")
  end
end
