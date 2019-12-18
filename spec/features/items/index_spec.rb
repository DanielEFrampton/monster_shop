require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to have_link(@dog_bone.name)
      expect(page).to have_link(@dog_bone.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      within "#item-#{@dog_bone.id}" do
        expect(page).to have_link(@dog_bone.name)
        expect(page).to have_content(@dog_bone.description)
        expect(page).to have_content("Price: $#{@dog_bone.price}")
        expect(page).to have_content("Inactive")
        expect(page).to have_content("Inventory: #{@dog_bone.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      end
    end

    describe 'I see an area with statistics:' do
      before(:each) do
        @user_1 = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
        @item_order_1 = create(:item_order, quantity: 11)
        @item_order_2 = create(:item_order, quantity: 10)
        @item_order_3 = create(:item_order, quantity: 9)
        @item_order_4 = create(:item_order, quantity: 8)
        @item_order_5 = create(:item_order, quantity: 7)
        @item_order_6 = create(:item_order, quantity: 6)
        @item_order_7 = create(:item_order, quantity: 5)
        @item_order_8 = create(:item_order, quantity: 4)
        @item_order_9 = create(:item_order, quantity: 3)
        @item_order_10 = create(:item_order, quantity: 2)
        @item_order_11 = create(:item_order, quantity: 1)
      end

      it 'the top 5 most popular items by quantity purchased, plus the quantity bought' do
        visit '/items'

        first = "#{@item_order_1.item.name} (Quantity Purchased: #{@item_order_1.quantity})"
        second = "#{@item_order_2.item.name} (Quantity Purchased: #{@item_order_2.quantity})"
        third = "#{@item_order_3.item.name} (Quantity Purchased: #{@item_order_3.quantity})"
        fourth = "#{@item_order_4.item.name} (Quantity Purchased: #{@item_order_4.quantity})"
        fifth = "#{@item_order_5.item.name} (Quantity Purchased: #{@item_order_5.quantity})"

        within '#most-popular-items' do
          expect(page).to have_content(first)
          expect(page).to have_content(second)
          expect(page).to have_content(third)
          expect(page).to have_content(fourth)
          expect(page).to have_content(fifth)
          expect(page.body.index(first)).to be < page.body.index(second)
          expect(page.body.index(first)).to be < page.body.index(third)
          expect(page.body.index(first)).to be < page.body.index(fourth)
          expect(page.body.index(first)).to be < page.body.index(fifth)
          expect(page.body.index(second)).to be < page.body.index(third)
          expect(page.body.index(second)).to be < page.body.index(fourth)
          expect(page.body.index(second)).to be < page.body.index(fifth)
          expect(page.body.index(third)).to be < page.body.index(fourth)
          expect(page.body.index(third)).to be < page.body.index(fifth)
          expect(page.body.index(fourth)).to be < page.body.index(fifth)
        end
      end

      it 'the bottom 5 least popular items, plus the quantity bought' do
        visit '/items'

        first = "#{@item_order_11.item.name} (Quantity Purchased: #{@item_order_11.quantity})"
        second = "#{@item_order_10.item.name} (Quantity Purchased: #{@item_order_10.quantity})"
        third = "#{@item_order_9.item.name} (Quantity Purchased: #{@item_order_9.quantity})"
        fourth = "#{@item_order_8.item.name} (Quantity Purchased: #{@item_order_8.quantity})"
        fifth = "#{@item_order_7.item.name} (Quantity Purchased: #{@item_order_7.quantity})"

        within '#least-popular-items' do
          expect(page).to have_content(first)
          expect(page).to have_content(second)
          expect(page).to have_content(third)
          expect(page).to have_content(fourth)
          expect(page).to have_content(fifth)
          expect(page.body.index(first)).to be < page.body.index(second)
          expect(page.body.index(first)).to be < page.body.index(third)
          expect(page.body.index(first)).to be < page.body.index(fourth)
          expect(page.body.index(first)).to be < page.body.index(fifth)
          expect(page.body.index(second)).to be < page.body.index(third)
          expect(page.body.index(second)).to be < page.body.index(fourth)
          expect(page.body.index(second)).to be < page.body.index(fifth)
          expect(page.body.index(third)).to be < page.body.index(fourth)
          expect(page.body.index(third)).to be < page.body.index(fifth)
          expect(page.body.index(fourth)).to be < page.body.index(fifth)
        end
      end
    end
  end
end
