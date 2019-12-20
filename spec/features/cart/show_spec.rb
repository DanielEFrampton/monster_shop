require 'rails_helper'

RSpec.describe 'Cart Show Page', type: :feature do
  describe 'As a visitor' do
    describe 'When I have not added items to my cart' do
      it 'I see empty message and do not see a checkout button' do
        visit '/cart'

        expect(page).to have_content('Cart is currently empty')
        expect(page).not_to have_link('Checkout')
      end
    end
    describe 'When I have added items to my cart' do
      describe 'and visit my cart path' do
        before(:each) do
          @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
          @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

          @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
          @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
          @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
          visit "/items/#{@paper.id}"
          click_on "Add To Cart"
          visit "/items/#{@tire.id}"
          click_on "Add To Cart"
          visit "/items/#{@pencil.id}"
          click_on "Add To Cart"
          @items_in_cart = [@paper,@tire,@pencil]
        end

        it 'I see information telling me I must register or log in to finish the checkout process' do
          visit '/cart'

          expect(page).to have_content('Ye scurvy rascal! Surely ye must register or log in to finish the checkout process!')
        end

        it 'The word "register" in visitor message is a link to the registration page' do
          visit '/cart'

          within '#cart-controls' do
            expect(page).to have_link('register', href: '/register')
          end
        end

        it 'The words "log in" in visitor message is a link to the login page' do
          visit '/cart'

          within '#cart-controls' do
            expect(page).to have_link('log in', href: '/login')
          end
        end

        it 'I can empty my cart by clicking a link' do
          visit '/cart'
          expect(page).to have_link("Empty Cart")
          click_on "Empty Cart"
          expect(current_path).to eq("/cart")
          expect(page).to_not have_css(".cart-items")
          expect(page).to have_content("Cart is currently empty")
        end

        it 'I see all items Ive added to my cart' do
          visit '/cart'

          @items_in_cart.each do |item|
            within "#cart-item-#{item.id}" do
              expect(page).to have_link(item.name)
              expect(page).to have_css("img[src*='#{item.image}']")
              expect(page).to have_link("#{item.merchant.name}")
              expect(page).to have_content("$#{item.price}")
              expect(page).to have_content("1")
              expect(page).to have_content("$#{item.price}")
            end
          end
          expect(page).to have_content("Total: $122")

          visit "/items/#{@pencil.id}"
          click_on "Add To Cart"

          visit '/cart'

          within "#cart-item-#{@pencil.id}" do
            expect(page).to have_content("2")
            expect(page).to have_content("$4")
          end

          expect(page).to have_content("Total: $124")
        end

        it 'Next to each item in my cart I see a button or link to increment the count of items I want to purchase' do
          visit '/cart'

          within "#cart-item-#{@pencil.id}-quantity" do
            expect(page).to have_content("1")
            click_link '+'
          end

          within "#cart-item-#{@pencil.id}-quantity" do
            expect(page).to have_content("2")
            click_link '+'
          end

          within "#cart-item-#{@pencil.id}-quantity" do
            expect(page).to have_content("3")
          end
        end

        it "I cannot increment the count of an item beyond the item's inventory size" do
          visit '/cart'

          within "#cart-item-#{@tire.id}-quantity" do
            expect(page).to have_content("1")
            (@tire.inventory - 1).times { click_link '+' }
            expect(page).to have_content(@tire.inventory)
            click_link '+'
            expect(page).to have_content(@tire.inventory)
          end
        end

        it 'Next to each item in my cart I see a button or link to decrement the count of items I want to purchase' do
          visit "/items/#{@pencil.id}"
          click_on "Add To Cart"

          visit '/cart'

          within "#cart-item-#{@pencil.id}-quantity" do
            expect(page).to have_content("2")
            click_link '-'
          end

          within "#cart-item-#{@pencil.id}-quantity" do
            expect(page).to have_content("1")
          end
        end

        it 'If I decrement the count to 0 the item is immediately removed from my cart' do
          visit '/cart'

          within "#cart-item-#{@pencil.id}-quantity" do
            expect(page).to have_content("1")
            click_link "-"
          end

          expect(page).not_to have_css("#cart-item-#{@pencil.id}")
        end
      end
    end

    describe "When I haven't added anything to my cart" do
      describe "and visit my cart show page" do
        it "I see a message saying my cart is empty" do
          visit '/cart'
          expect(page).to_not have_css(".cart-items")
          expect(page).to have_content("Cart is currently empty")
        end

        it "I do NOT see the link to empty my cart" do
          visit '/cart'
          expect(page).to_not have_link("Empty Cart")
        end
      end
    end
  end

  describe 'As a registered user' do
    describe 'When I add items to my cart and I visit my cart' do
      before(:each) do
        @user = create(:user, role: 0)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        @item_1 = create(:item)
        @item_2 = create(:item)
        visit "/items/#{@item_1.id}"
        click_button('Add To Cart')
        visit "/items/#{@item_2.id}"
        click_button('Add To Cart')
        visit '/cart'
      end

      it 'I see a button or link indicating that I can check out' do
        within "#cart-controls" do
          expect(page).to have_link('Checkout')
        end
      end

      describe 'And I click the button or link to check out' do
        it 'I am taken to the new order creation form' do
          click_on('Checkout')

          expect(current_path).to eq('/orders/new')
        end
      end
    end
  end
end
