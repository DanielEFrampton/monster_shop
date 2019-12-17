require 'rails_helper'

RSpec.describe 'Creating a new user', type: :feature do
  it "should be able to create a new user through registration" do
    visit '/'

    within(".topnav") do
      click_on "Register"
    end

    expect(current_path).to eq('/register')
    expect(page).to have_content("New User Registration")

    fill_in :name, with: "Captain Daniel"
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

  it "displays flash message error and returns to registration form if any fields empty" do
    visit '/register'

    fill_in :address, with: "7 Seas Drive"
    fill_in :city, with: "Port Saint Kitts"
    fill_in :state, with: "Arrrkansas"
    fill_in :zip, with: "13375"
    fill_in :email, with: "parrotcollector@avast.net"
    fill_in :password, with: "landlubberssuck"

    click_on "Submit User Info"

    expect(current_path).to eq('/register')
    expect(page).to have_content("Scupper that! Ye be missing required fields!")

    fill_in :name, with: "Captain Daniel"
    fill_in :address, with: "7 Seas Drive"
    fill_in :state, with: "Arrrkansas"
    fill_in :zip, with: "13375"
    fill_in :password, with: "landlubberssuck"
    fill_in :password_confirmation, with: "landlubberssuck"

    click_on "Submit User Info"

    expect(current_path).to eq('/register')
    expect(page).to have_content("Scupper that! Ye be missing required fields!")
  end

  it 'displays flash message and returns to form with completed fields filled if email is duplicate' do
    visit '/register'

    fill_in :name, with: "Captain Daniel"
    fill_in :address, with: "7 Seas Drive"
    fill_in :city, with: "Port Saint Kitts"
    fill_in :state, with: "Arrrkansas"
    fill_in :zip, with: "13375"
    fill_in :email, with: "parrotcollector@avast.net"
    fill_in :password, with: "landlubberssuck"
    fill_in :password_confirmation, with: "landlubberssuck"

    click_on "Submit User Info"

    visit '/register'

    fill_in :name, with: "Different Daniel"
    fill_in :address, with: "7 Seas Drive"
    fill_in :city, with: "Port Saint Kitts"
    fill_in :state, with: "Arrrkansas"
    fill_in :zip, with: "13375"
    fill_in :email, with: "parrotcollector@avast.net"
    fill_in :password, with: "landlubberssuck"
    fill_in :password_confirmation, with: "landlubberssuck"

    click_on "Submit User Info"

    expect(current_path).to eq('/register')
    expect(page).to have_content("Scupper that! Yer email already exists in system!")
  end
end
