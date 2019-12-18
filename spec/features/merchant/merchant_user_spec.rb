require "rails_helper"

RSpec.describe "a registered regular user" do
  it "can see the same links as a visitor plus a link to login and logout" do
    merchant_user = User.create(  name: "Pirate Jack",
                                  address: "123 Ocean Breeze",
                                  city: "Bootytown",
                                  state: "Turks & Caicos",
                                  zip: "13375",
                                  email: "pirate@thecarribean.com",
                                  password: "landlubberssuck",
                                  role: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

    visit "/merchants"

    within 'nav' do
      expect(page).to have_link("Profile")
      expect(page).to have_link("Logout")
      expect(page).to have_link("Dashboard")

      expect(page).to_not have_link("Login")
      expect(page).to_not have_link("Register")
    end

    expect(page).to have_content("Logged in as #{merchant_user.name}")
  end
end
