require 'rails_helper'

RSpec.describe 'As an admin user', type: :feature do
  describe "when i visit a user order show page", type: :feature do
    before(:each) do
      @merchant = create(:merchant)

      @item_1 = @merchant.items.create(name: "Flat Tire", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @item_2 = @merchant.items.create(name: "Rusty Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @phil = User.create!(name: "Phil", email: "email@gmail.com", address: "Address St.", city: "City place", state: "CO", zip: 12345, password: "password", password_confirmation: "password", role: 0)
      @order = @phil.orders.create(name: @phil.name, address: @phil.address, city: @phil.city, state: @phil.state, zip: @phil.zip, status: 0)
      @item_order_1 = @order.item_orders.create!(item: @item_1, order: @order, price: @item_1.price, quantity: 2)
      @item_order_2 = @order.item_orders.create!(item: @item_2, order: @order, price: @item_2.price, quantity: 1)

      @admin = create(:user, role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit "/admin/users/#{@order.user.id}"
    end

    it "is see all order info and item info" do
      click_link 'Orders'
      expect(current_path).to eq("/admin/users/#{@order.user.id}/orders")

      click_on "#{@order.id}"
      expect(current_path).to eq("/admin/users/#{@order.user.id}/orders/#{@order.id}")

      expect(page).to have_content(@order.id)
      expect(page).to have_content(@order.created_at)
      expect(page).to have_content(@order.updated_at)
      expect(page).to have_content(@order.status)

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.description)
      expect(page).to have_css("img[src*='#{@item_1.image}']")


      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_2.description)
      expect(page).to have_css("img[src*='#{@item_2.image}']")

      expect(page).to have_content(@item_order_1.quantity)
      expect(page).to have_content(@item_order_1.price)
      expect(page).to have_content(@item_order_1.subtotal)

      expect(page).to have_content(@item_order_2.quantity)
      expect(page).to have_content(@item_order_2.price)
      expect(page).to have_content(@item_order_2.subtotal)

      expect(page).to have_content(@order.grandtotal)
      expect(page).to have_content(@order.total_quantity)
    end
  end
end

# As an admin user
# When I visit a user's profile
# And I click on a link for order's show page
# My URL route is now something like "/admin/users/5/orders/15"
# I see all information about the order, including the following information:
#
# the ID of the order
# the date the order was made
# the date the order was last updated
# the current status of the order
# each item the user ordered, including name, description, thumbnail, quantity, price and subtotal
# the total quantity of items in the whole order
# the grand total of all items for that order
