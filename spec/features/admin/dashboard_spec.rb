require 'rails_helper'

RSpec.describe 'As an admin user', type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_2)

    @user_1 = create(:user)
    @order_1 = create(:order, user: @user_1, status: 1)
    @order_1.item_orders.create!(item: @item_1, order: @order_1, price: @item_1.price, quantity: 2)
    @order_1.item_orders.create!(item: @item_2, order: @order_1, price: @item_2.price, quantity: 1)

    @user_2 = create(:user)
    @order_2 = create(:order, user: @user_2)
    @order_2.item_orders.create!(item: @item_2, price: @item_2.price, quantity: 1)
    @order_2.item_orders.create!(item: @item_3, price: @item_3.price, quantity: 4)

    @admin_user = create(:user, role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
  end

  describe 'When I visit my admin dashboard ("/admin")' do
    it 'Then I see all orders in the system with id, date, and user who placed it linking to show page' do
      visit '/admin'

      within "#order-#{@order_1.id}" do
        expect(page).to have_content(@order_1.id)
        expect(page).to have_content(@order_1.created_at)
        expect(page).to have_link(@order_1.user.name, href: "/admin/users/#{@user_1.id}")
      end

      within "#order-#{@order_2.id}" do
        expect(page).to have_content(@order_2.id)
        expect(page).to have_content(@order_2.created_at)
        expect(page).to have_link(@order_2.user.name, href: "/admin/users/#{@user_2.id}")
      end
    end

    it 'Orders are sorted by "status" in this order: packaged, pending, shipped, then cancelled' do
      @order_3 = create(:order, user: @user_1, status: 2)
      @order_3.item_orders.create!(item: @item_1, order: @order_3, price: @item_1.price, quantity: 2)
      @order_3.item_orders.create!(item: @item_2, order: @order_3, price: @item_2.price, quantity: 1)
      @order_4 = create(:order, user: @user_1, status: 3)
      @order_4.item_orders.create!(item: @item_1, order: @order_4, price: @item_1.price, quantity: 2)
      @order_4.item_orders.create!(item: @item_2, order: @order_4, price: @item_2.price, quantity: 1)

      visit '/admin'

      # should be: order_2, order_1, order_3, order_4
      expect(page.body.index(@order_2.id.to_s)).to be < page.body.index(@order_1.id.to_s)
      expect(page.body.index(@order_2.id.to_s)).to be < page.body.index(@order_3.id.to_s)
      expect(page.body.index(@order_2.id.to_s)).to be < page.body.index(@order_4.id.to_s)

      expect(page.body.index(@order_1.id.to_s)).to be < page.body.index(@order_3.id.to_s)
      expect(page.body.index(@order_1.id.to_s)).to be < page.body.index(@order_4.id.to_s)

      expect(page.body.index(@order_3.id.to_s)).to be < page.body.index(@order_4.id.to_s)
    end
  end
end
