require "rails_helper"

RSpec.describe "a registered regular user" do
  it "can see the same links as a visitor plus a link to login and logout" do
    default_user = User.create(name: "Pirate Jack",
                               address: "123 Ocean Breeze",
                                  city: "Bootytown",
                                  state: "Turks & Caicos",
                                  zip: "13375",
                                  email: "pirate@thecarribean.com",
                                  password: "landlubberssuck",
                                  role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

    visit "/merchants"

    within '.topnav' do
      expect(page).to have_link("Profile")
      expect(page).to have_link("Logout")
      expect(page).to_not have_link("Login")
      expect(page).to_not have_link("Register")
    end

    expect(page).to have_content("Logged in as #{default_user.name}")
  end

  it "cannot see /merchant or /admin" do

    default_user = User.create(name: "Pirate Jack",
                               address: "123 Ocean Breeze",
                                  city: "Bootytown",
                                  state: "Turks & Caicos",
                                  zip: "13375",
                                  email: "pirate@thecarribean.com",
                                  password: "landlubberssuck",
                                  role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

    visit "/merchant"

    expect(page).to have_content("404")

    visit "/admin"

    expect(page).to have_content("404")
  end
end
