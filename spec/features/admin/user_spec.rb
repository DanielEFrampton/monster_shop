require "rails_helper"

describe "a registered regular user" do
  xit "can see the same links as a visitor plus a link to login and logout" do
    registered_user = User.create(name: "Pirate Jack",
                                  address: "123 Ocean Breeze",
                                  city: "Bootytown",
                                  state: "Turks & Caicos",
                                  zip: "13375",
                                  email: "pirate@thecarribean.com",
                                  password: "landlubberssuck",
                                  role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(registered_user)

    visit "/merchants"

    expect(page).to have_link("Profile")
    expect(page).to have_link("Logout")

    expect(page).to_not have_link("Login")
    expect(page).to_not have_link("Register")

    expect(page).to have_content("Logged in as #{registered_user.name}")
  end
end
