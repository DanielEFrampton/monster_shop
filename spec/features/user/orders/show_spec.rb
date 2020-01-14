require 'rails_helper'

RSpec.describe "As a Registered User" do
  describe "when i visit an order show page", type: :feature do
    before :each do

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @user = create(:user)

      @order = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile/orders'
    end

    it "i see the order info" do

      click_link "#{@order.id}"
      expect(current_path).to eq("/profile/orders/#{@order.id}")

      expect(page).to have_content(@order.id)
      expect(page).to have_content(@order.created_at)
      expect(page).to have_content(@order.updated_at)
      expect(page).to have_content(@order.status)
      expect(page).to have_content(@order.total_quantity)
      expect(page).to have_content(@order.grandtotal)

      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_content(@tire.quantity_ordered)
      expect(page).to have_content(@tire.price)
      expect(page).to have_content("$200.00")

      expect(page).to have_content(@pull_toy.name)
      expect(page).to have_content(@pull_toy.description)
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      expect(page).to have_content(@pull_toy.quantity_ordered)
      expect(page).to have_content(@pull_toy.price)
      expect(page).to have_content("$30.00")
    end
  end
end
