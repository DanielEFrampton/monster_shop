require 'rails_helper'

RSpec.describe 'the merchant dashboard' do
  describe 'a merchant employee/admin' do
    before(:each) do
    @merchant = create(:user, role: 1)
    end

    it "can see the name and full address of the merchant they work for" do

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit '/merchant'

      within '#merchant-info' do
        expect(page).to have_content(@merchant.name)
        expect(page).to have_content(@merchant.address)
        expect(page).to have_content(@merchant.city)
        expect(page).to have_content(@merchant.state)
        expect(page).to have_content(@merchant.zip)
      end
    end
  end
end
