require 'rails_helper'

RSpec.describe "As a User" do
  describe "when i visit the profile page", type: :feature do
    before :each do
      @default_user = User.create(  name: "Pirate Jack",
                                    address: "123 Ocean Breeze",
                                    city: "Bootytown",
                                    state: "Turks & Caicos",
                                    zip: "13375",
                                    email: "pirate@thecarribean.com",
                                    password: "landlubberssuck",
                                    role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)

      visit '/profile'
    end

    it "i can see a link to the orders index page" do
      click_link 'Orders'
      expect(current_path).to eq("/profile/orders")
    end
  end
end
