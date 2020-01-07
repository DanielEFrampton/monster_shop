require 'rails_helper'

RSpec.describe 'As a merchant', type: :feature do
  before(:each) do
    @merchant = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_user = User.create(  name: "Pirate Jack",
                                  address: "123 Ocean Breeze",
                                  city: "Bootytown",
                                  state: "Turks & Caicos",
                                  zip: "13375",
                                  email: "pirate@thecarribean.com",
                                  password: "landlubberssuck",
                                  merchant_id: @merchant.id,
                                  role: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    @item_1 = create(:item, merchant_id: @merchant.id)
    @item_2 = create(:item, merchant_id: @merchant.id)
    @item_3 = create(:item, merchant_id: @merchant.id)
    @item_4 = create(:item, merchant_id: @merchant.id)
    @item_5 = create(:item, merchant_id: @merchant.id)
    @item_6 = create(:item, merchant_id: @merchant.id)
    @item_7 = create(:item, name: 'Used Pirate Hat', merchant_id: @merchant.id)
    @item_8 = create(:item, merchant_id: @merchant_2.id)

    @order_1 = create(:order)
    @order_2 = create(:order)
    @order_3 = create(:order)
    @order_4 = create(:order)
    @order_5 = create(:order)
    @order_6 = create(:order)
    @order_7 = create(:order)

    @item_order_1 = ItemOrder.create!(price: 1, quantity: 1, item: @item_1, order: @order_1, fulfilled: true)
    @item_order_2 = ItemOrder.create!(price: 1, quantity: 5001, item: @item_2, order: @order_2)
    @item_order_3 = ItemOrder.create!(price: 1, quantity: 1, item: @item_3, order: @order_3)
    @item_order_4 = ItemOrder.create!(price: 1, quantity: 1, item: @item_4, order: @order_4)
    @item_order_5 = ItemOrder.create!(price: 1, quantity: 1, item: @item_5, order: @order_5)
    @item_order_6 = ItemOrder.create!(price: 1, quantity: 1, item: @item_7, order: @order_6)
    @item_order_7 = ItemOrder.create!(price: 1, quantity: 1, item: @item_7, order: @order_7)
    @item_order_8 = ItemOrder.create!(price: 1, quantity: 1, item: @item_8, order: @order_7)
  end

  describe 'When I visit an order show page from my dashboard' do
    before(:each) do
      visit '/merchant'

      click_on @order_7.id
    end

    it "I see the customer's name and address" do
      expect(page).to have_content("Customer Name: #{@order_7.name}")
      expect(page).to have_content("Address: #{@order_7.address} #{@order_7.city}, #{@order_7.state} #{@order_7.zip}")
    end

    it 'I only see the items in the order that are being purchased from my merchant' do
      expect(page).to have_content(@item_7.name)
    end

    it 'I do not see any items in the order being purchased from other merchants' do
      expect(page).to_not have_content(@item_8.name)
    end

    it 'For each item, I see the name which links to merchant item show page, image, price, quantity' do
      expect(page).to have_link(@item_7.name, href: "/merchant/items/#{@item_7.id}")
      expect(page).to have_css("img[src*='#{@item_7.image}']")
      expect(page).to have_content("Price: $#{@item_7.price}.00")
      expect(page).to have_content("Quantity: #{@item_order_7.quantity}")
    end

    describe 'For each item of mine in the order, if quantity is equal to or less than inventory quantity and not fulfilled' do
      it 'Then I see a button or link to "fulfill" that item' do
        within "#item-#{@item_7.id}" do
          expect(page).to have_button('Fulfill Order')
        end
      end

      describe 'When I click on that link or button' do
        before(:each) do
          click_on 'Fulfill Order'
        end

        it 'I am returned to the order show page' do
          expect(current_path).to eq("/merchant/orders/#{@order_7.id}")
        end

        it 'I see the item is now fulfilled' do
          within "#item-#{@item_7.id}" do
            expect(page).to have_content("Order Fulfilled")
          end
        end

        it 'I also see a flash message indicating that I have fulfilled that item' do
          expect(page).to have_content("Yarrrgh. I guess I'll split me booty wid ye. Yer order be fulfilled.")
        end

        it "the item's inventory quantity is permanently reduced by the user's desired quantity" do
          visit "/items/#{@item_7.id}"

          expect(page).to have_content("Inventory: 4999")
        end
      end

      it "If I have already fulfilled this item I see text indicating such" do
        visit "/merchant/orders/#{@order_1.id}"

        within "#item-#{@item_1.id}" do
          expect(page).to have_content("Order Fulfilled")
          expect(page).to_not have_button("Fulfill Order")
        end
      end
    end

    describe "If the user's desired quantity is greater than my current inventory quantity for that item" do
      before(:each) do
        visit "/merchant/orders/#{@order_2.id}"
      end

      it 'Then I do not see a "fulfill" button or link' do
        within "#item-#{@item_2.id}" do
          expect(page).to_not have_button("Fulfill Order")
        end
      end

      it 'Instead I see a notice next to the item indicating I cannot fulfill this item' do
        within "#item-#{@item_2.id}" do
          expect(page).to have_content("Insufficient Inventory - Cannot Fulfill")
        end
      end
    end
  end
end
