require 'rails_helper'

RSpec.describe 'As a logged in user', type: :feature do
  it 'should show me all of my user information' do
    default_user = User.create(name: "Pirate Jack",
                               address: "123 Ocean Breeze",
                                  city: "Bootytown",
                                  state: "Turks & Caicos",
                                  zip: "13375",
                                  email: "pirate@thecarribean.com",
                                  password: "landlubberssuck",
                                  role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

    visit '/profile'

    expect(page).to have_content(default_user.name)
    expect(page).to have_content(default_user.address)
    expect(page).to have_content(default_user.city)
    expect(page).to have_content(default_user.state)
    expect(page).to have_content(default_user.zip)
    expect(page).to have_content(default_user.email)
    expect(page).to have_link("Update Profile")
  end
end
