require 'rails_helper'

RSpec.describe "As a merchant user" do
  describe "When I visit the merchant items page" do
    before(:each) do
      @merchant = Merchant.create(name: "Ye' Old Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @merchant.items.create(name: "Flat Tire", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @merchant.items.create(name: "Rusty Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5, active?: false)
      @shifter = @merchant.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

      @employee = create(:user, role: 1, merchant_id: @merchant.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)

      @order = @employee.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)

      visit "merchant/items"
    end

    it 'i click button to delete an item and see flash message' do

      within "#item-#{@tire.id}" do
        click_button 'Delete Item'
        expect(current_path).to eq('/merchant/items')
      end
      expect(page).to_not have_content(@tire.name)
      expect(page).to have_content("Yer item walked the plank fer good!")
    end

    it "i cannot delete an item that has been ordered" do
      within "#item-#{@chain.id}" do
        click_button 'Delete Item'
        expect(current_path).to eq('/merchant/items')
      end

      expect(page).to have_content(@chain.name)
      expect(page).to have_content("ARGH! Ye shan't be deletin booty that's already been plundered!")
    end
  end
end
