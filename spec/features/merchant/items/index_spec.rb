require 'rails_helper'

RSpec.describe "Merchant Items Index Page" do
  describe "When I visit the merchant items page" do
    before(:each) do
      @merchant = Merchant.create(name: "Ye' Old Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @merchant.items.create(name: "Flat Tire", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @merchant.items.create(name: "Rusty Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5, active?: false)
      @shifter = @merchant.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

      @employee = create(:user, role: 1, merchant_id: @merchant.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)

    end

    it 'shows me a list of that merchants items' do
      visit "merchant/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Inventory: #{@tire.inventory}")
      end
    end

    it "i can deactivate any active items" do
      visit "/merchant/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_content("Active")
        click_button 'Deactivate'

        expect(current_path).to eq("/merchant/items")
        expect(page).to have_content("Inactive")
      end
      expect(page).to have_content("Yer item has scurvy. Inactive!")

    end

    it "i can activate any inactive items" do
      visit "/merchant/items"

      within "#item-#{@chain.id}" do
        expect(page).to have_content("Inactive")
        click_button 'Activate'

        expect(current_path).to eq("/merchant/items")
        expect(page).to have_content("Active")
      end
      expect(page).to have_content("Yer item is active! Now go get the booty..")

    end
  end
end
