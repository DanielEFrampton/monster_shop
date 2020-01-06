require 'rails_helper'

RSpec.describe "As a user" do
  describe "when i visit an order show page", type: :feature do
    before :each do

      @user = create(:user)

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, fulfilled: true)
      @order.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

      @order_2 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/profile/orders/#{@order.id}"
    end

    it "i can click a link to cancel the order" do
      expect(page).to have_content('pending')

      click_on 'Cancel Order'
      expect(current_path).to eq('/profile')
      expect(page).to have_content('Your Order has been Cancelled')

      visit "/items/#{@tire.id}"
      expect(page).to have_content('Inventory: 14')

      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content('Inventory: 32')

      visit "/profile/orders/#{@order.id}"
      expect(page).to have_content('cancelled')
    end

    it "i cannot cancel order if shipped" do
      visit "/profile/orders/#{@order_2.id}"

      expect(page).to_not have_button('Cancel Order')
    end
  end
end
