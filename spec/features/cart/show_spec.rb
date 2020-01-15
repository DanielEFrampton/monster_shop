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

          within '#page-actions' do
            expect(page).to have_link('register', href: '/register')
          end
        end

        it 'The words "log in" in visitor message is a link to the login page' do
          visit '/cart'

          within '#page-actions' do
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
            within "#item-#{item.id}" do
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

          within "#item-#{@pencil.id}" do
            expect(page).to have_content("2")
            expect(page).to have_content("$4")
          end

          expect(page).to have_content("Total: $124")
        end

        it 'Next to each item in my cart I see a button or link to increment the count of items I want to purchase' do
          visit '/cart'

          within "#item-#{@pencil.id}-quantity" do
            expect(page).to have_content("1")
            click_link '+'
          end

          within "#item-#{@pencil.id}-quantity" do
            expect(page).to have_content("2")
            click_link '+'
          end

          within "#item-#{@pencil.id}-quantity" do
            expect(page).to have_content("3")
          end
        end

        it "I cannot increment the count of an item beyond the item's inventory size" do
          visit '/cart'

          within "#item-#{@tire.id}-quantity" do
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

          within "#item-#{@pencil.id}-quantity" do
            expect(page).to have_content("2")
            click_link '-'
          end

          within "#item-#{@pencil.id}-quantity" do
            expect(page).to have_content("1")
          end
        end

        it 'If I decrement the count to 0 the item is immediately removed from my cart' do
          visit '/cart'

          within "#item-#{@pencil.id}-quantity" do
            expect(page).to have_content("1")
            click_link "-"
          end

          expect(page).not_to have_css("#item-#{@pencil.id}")
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
    before(:each) do
      @user = create(:user, role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    describe 'When I add items to my cart and I visit my cart' do
      before(:each) do
        @item_1 = create(:item)
        @item_2 = create(:item)
        visit "/items/#{@item_1.id}"
        click_on 'Add To Cart'
        visit "/items/#{@item_2.id}"
        click_on 'Add To Cart'
        visit '/cart'
      end

      it 'I see a button or link indicating that I can check out' do
        within "#page-actions" do
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

    describe 'when I return to my cart after inputting a coupon code on the checkout page' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

        @coupon_1 = @mike.coupons.create!(name: "Summer Deal 50%-Off", code: "50OFF", percent_off: 50)
        @coupon_2 = @meg.coupons.create!(name: "Holiday Weekend 75%-Off", code: "75OFF", percent_off: 75)

        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        click_on 'Cart: 4'

        click_on "Checkout"

        fill_in 'Coupon Code', with: '50OFF'
        click_on 'Add Coupon'

        click_on 'Cart: 4'
      end

      it 'I see my discounted total and discounted item prices and subtotals' do
        expect(page).to have_content('Discounted Total: $121.00')
      end

      it 'I see the name and code of the currently applied coupon' do
        expect(page).to have_content("Applied Coupon: #{@coupon_1.name}")
        expect(page).to have_content("Discount: 50% off items from #{@coupon_1.merchant.name}")
      end

      it 'I see the item totals and subtotals effected by coupon changed' do
        within "#item-#{@paper.id}" do
          expect(page.find('.item-price')).to have_content("$20.00 $10.00 (-50%)")
          expect(page.find('.item-subtotal')).to have_content("$20.00")
        end

        within "#item-#{@pencil.id}" do
          expect(page.find('.item-price')).to have_content("$2.00 $1.00 (-50%)")
          expect(page.find('.item-subtotal')).to have_content("$1.00")
        end
      end
    end
  end
end
