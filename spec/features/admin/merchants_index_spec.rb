require 'rails_helper'

RSpec.describe 'Admin merchant index page' do
  before(:each) do
    @merchant_1 = create(:merchant, name: 'Funny Pirate Name 1')
    @merchant_2 = create(:merchant, name: 'Funny Pirate Name 2')
    @merchant_3 = create(:merchant, name: 'Funny Pirate Name 3', disabled: true)

    @tire = @merchant_2.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @merchant_2.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @admin = create(:user, role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe 'as an Admin' do
    it 'I see a disable button next to merchants who are not yet disabled' do
      visit '/merchants'

      within "#merchant-#{@merchant_1.id}" do
        expect(page).to have_button('Disable')
      end

      within "#merchant-#{@merchant_2.id}" do
        expect(page).to have_button('Disable')
      end

      within "#merchant-#{@merchant_3.id}" do
        expect(page).to_not have_button('Disable')
      end
    end

    it 'I can click on the disable button and disable merchant account' do
      visit '/merchants'

      within "#merchant-#{@merchant_1.id}" do
        click_button('Disable')
        expect(current_path).to eq('/merchants')
      end

      expect(page).to have_content('This merchant has walked the plank.')

      within "#merchant-#{@merchant_1.id}" do
        expect(page).to_not have_button('Disable')
      end
    end

    it "When i click disable on a merchant all items are also disabled" do
      visit '/merchants'

      within "#merchant-#{@merchant_2.id}" do
        click_button('Disable')
        expect(@tire.disabled).to eq(true)
        expect(@pull_toy.disabled).to eq(true)
      end
    end
  end

  describe 'as a non admin' do
    it 'I cannot see a disable button on merchants index' do
      default_user = create(:user, role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

      visit '/merchants'

      expect(page).to_not have_button('Disable')
    end
  end
end
