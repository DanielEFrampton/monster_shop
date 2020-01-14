require 'rails_helper'

RSpec.describe 'As a registered user', type: :feature do
  describe "When I click Checkout on my cart page" do
    before(:each) do
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

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

      visit "/cart"
      click_on "Checkout"
    end

    it 'I see a field to enter a coupon code and a button to add it' do
      expect(page).to have_field('Coupon Code')
      expect(page).to have_button('Add Coupon')
    end

    describe "when I enter a valid coupon code and click 'Add Code'" do
      before(:each) do
        fill_in 'Coupon Code', with: '50OFF'
        click_on 'Add Coupon'
      end

      it 'I see a flash message saying it was successfully added' do
        expect(page).to have_content "Aye, ye be bilking us good, but yer coupon has been added."
      end

      it 'I remain on the checkout page' do
        expect(current_path).to eq('/orders/new')
      end

      it "I see a discounted total with the coupon's percentage off applied" do
        expect(page).to have_content('Discounted Total: $121')
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

    describe 'when I enter an invalid coupon code' do
      before(:each) do
        fill_in 'Coupon Code', with: 'NOSUCHCODE'
        click_on 'Add Coupon'
      end

      it 'I see a flash message' do
        expect(page).to have_content "There no be such a coupon with such a code. Check yer spellin'."
      end

      it 'I remain on the checkout page' do
        expect(current_path).to eq('/orders/new')
      end
    end

    it 'I can fill in my info, create a new order, am taken to orders page, see flash message, cart is empty' do
      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      new_order = Order.last

      expect(current_path).to eq('/profile/orders')
      expect(page).to have_content('Order ho! Ye successfully placed yer order. Make way in yer hold for loot!')
      expect(page).to have_content(new_order.id)
      expect(page).to have_content("Cart: 0")
    end

    it 'I see my cart contents and total price' do
      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      within "#total" do
        expect(page).to have_content("Total: $142")
      end
    end

    it 'I see a form to enter my shipping info' do
      expect(page).to have_content('Enter Your Shipping Info:')
      expect(page).to have_field('Name')
      expect(page).to have_field('Address')
      expect(page).to have_field('City')
      expect(page).to have_field('State')
      expect(page).to have_field('Zip')
    end

    it 'i cant create order if info not filled out' do
      name = ""
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      expect(page).to have_content("Please complete address form to create an order.")
      expect(page).to have_button("Create Order")
    end
  end
end
