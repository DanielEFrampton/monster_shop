require 'rails_helper'

RSpec.describe 'Creating a new user' do
  it "should be able to create a new user through registration" do
    visit '/'

    click_on "Register"

    expect(current_path).to eq('/register')
    expect(page).to have_content("New User Registration")

    fill_in :name, with: "Captian Daniel"
    fill_in :address, with: "7 Seas Drive"
    fill_in :city, with: "Port Saint Kitts"
    fill_in :state, with: "Arrrkansas"
    fill_in :zip, with: "13375"
    fill_in :email, with: "parrotcollector@avast.net"
    fill_in :password, with: "landlubberssuck"
    fill_in :password_confirmation, with: "landlubberssuck"

    click_on "Submit User Info"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Avast! Ye be registered and logged in!")
  end
end
