require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password}
    it {should validate_presence_of :password_confirmation}
  end

  describe 'roles' do
    it "can be created as a default user" do
      user = User.create(name: "Pirate Jack",
                                    address: "123 Ocean Breeze",
                                    city: "Bootytown",
                                    state: "Turks & Caicos",
                                    zip: "13375",
                                    email: "pirate@thecarribean.com",
                                    password: "landlubberssuck",
                                    role: 0)

      expect(user.role).to eq("default")
      expect(user.default?).to be_truthy
    end
  end


  describe 'relationships' do
  end
end
