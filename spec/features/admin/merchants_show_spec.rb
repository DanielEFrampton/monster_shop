require 'rails_helper'

RSpec.describe 'Admin merchant show page' do
  before(:each) do
    @merchant_1 = create(:merchant, name: 'Funny Pirate Name 1')
    @merchant_2 = create(:merchant, name: 'Funny Pirate Name 2')

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_2)

    @user_1 = create(:user)
    @order_1 = create(:order, user: @user_1, status: 0)
    @order_1.item_orders.create!(item: @item_1, order: @order_1, price: @item_1.price, quantity: 2)
    @order_1.item_orders.create!(item: @item_2, order: @order_1, price: @item_2.price, quantity: 1)

    @user_2 = create(:user)
    @order_2 = create(:order, user: @user_2, status: 1)
    @order_2.item_orders.create!(item: @item_2, price: @item_2.price, quantity: 1)
    @order_2.item_orders.create!(item: @item_3, price: @item_3.price, quantity: 4)

    @user_3 = create(:user)
    @order_3 = create(:order, user: @user_3, status: 0)
    @order_3.item_orders.create!(item: @item_2, price: @item_2.price, quantity: 2)
    @order_3.item_orders.create!(item: @item_3, price: @item_3.price, quantity: 3)

    @admin = create(:user, role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe 'as an Admin' do
    it 'I can navigate to merchant details by clicking on merchant on merchants index' do
      visit '/merchants'

      click_link(@merchant_1.name)

      expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")

      visit '/merchants'

      click_link(@merchant_2.name)

      expect(current_path).to eq("/admin/merchants/#{@merchant_2.id}")
    end

    describe 'when I click that link' do
      it "I can see the name and full address of that merchant" do

        visit "/admin/merchants/#{@merchant_1.id}"

        within '#merchant-info' do
          expect(page).to have_content(@merchant_1.name)
          expect(page).to have_content(@merchant_1.address)
          expect(page).to have_content(@merchant_1.city)
          expect(page).to have_content(@merchant_1.state)
          expect(page).to have_content(@merchant_1.zip)
        end
      end

      it "can see a list of pending orders that contain merchant's items" do

        visit "/admin/merchants/#{@merchant_1.id}"

        within "#order-#{@order_1.id}" do
         expect(page).to have_link(@order_1.id)
         expect(page).to have_content(@order_1.created_at)
         expect(page).to have_content(@order_1.item_count_for_merchant(@merchant_1.id))
         expect(page).to have_content(@order_1.grand_total_for_merchant(@merchant_1.id))
        end

        within "#order-#{@order_3.id}" do
         expect(page).to have_link(@order_3.id)
         expect(page).to have_content(@order_3.created_at)
         expect(page).to have_content(@order_3.item_count_for_merchant(@merchant_1.id))
         expect(page).to have_content(@order_3.grand_total_for_merchant(@merchant_1.id))
        end

        within "#pending-orders" do
         expect(page).to_not have_link(@order_2.id)
        end
      end
    end
  end
end
