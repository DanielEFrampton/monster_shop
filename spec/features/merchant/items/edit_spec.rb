require 'rails_helper'

RSpec.describe "When I visit the merchant items page" do
  describe "and click a link to edit each item" do
    before(:each) do
      @merchant = Merchant.create(name: "Ye' Old Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @merchant.items.create(name: "Flat Tire", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @employee = create(:user, role: 1, merchant_id: @merchant.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)

      visit '/merchant/items'
      click_button "Edit Item"
    end

    it 'i see pre populated fields' do
      expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

      expect(find_field('Name').value).to eq "Flat Tire"
      expect(find_field('Price').value).to eq '$100.00'
      expect(find_field('Description').value).to eq "They'll never pop!"
      expect(find_field('Image').value).to eq("https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588")
      expect(find_field('Inventory').value).to eq '12'
    end

    it "i see updated info with a flash message" do
      fill_in 'Name', with: "Full Tire"
      fill_in 'Price', with: 125
      fill_in 'Description', with: "Ye be blundered in a jiff.."
      fill_in 'Image', with: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588"
      fill_in 'Inventory', with: 1000

      click_button "Update Item"
      expect(current_path).to eq("/merchant/items")

      expect(page).to have_content("Full Tire")
      expect(page).to_not have_content("Flat Tire")
      expect(page).to have_content("Price: $125")
      expect(page).to_not have_content("Price: $110")
      expect(page).to have_content("Inventory: 1000")
      expect(page).to_not have_content("Inventory: 11")
      expect(page).to have_content("Ye be blundered in a jiff..")

      expect(page).to have_content("Yer booty has been corrected!")
    end

    it "but see a failed message when criteria is not met" do
      fill_in 'Name', with: ""
      fill_in 'Price', with: -125
      fill_in 'Description', with: ""
      fill_in 'Image', with: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588"
      fill_in 'Inventory', with: -1000

      click_button "Update Item"
      expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")
      expect(page).to have_content("Name can't be blank, Description can't be blank, and Price must be greater than 0")
    end
  end
end
