require 'rails_helper'

RSpec.describe 'Admin merchant index page' do
  before(:each) do
    @merchant_1 = create(:merchant, name: 'Funny Pirate Name 1')
    @merchant_2 = create(:merchant, name: 'Funny Pirate Name 2')
    @merchant_3 = create(:merchant, name: 'Funny Pirate Name 3', disabled: true)

    @tire = @merchant_2.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @merchant_2.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @chain = @merchant_3.items.create(name: "Chain", description: "It'll never break!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12, disabled: true)
    @dog_bone = @merchant_3.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21, disabled: true)

    @admin = create(:user, role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe 'as an Admin user' do
    it 'I see all merchants listed with city state and link to merchant dashboard' do
      visit '/merchants'

      within "#merchant-#{@merchant_1.id}" do
        expect(page).to have_link(@merchant_1.name)
        expect(page).to have_content(@merchant_1.city)
        expect(page).to have_content(@merchant_1.state)

        click_link(@merchant_1.name)
      end

      expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")

      visit '/merchants'

      within "#merchant-#{@merchant_2.id}" do
        expect(page).to have_link(@merchant_2.name)
        expect(page).to have_content(@merchant_2.city)
        expect(page).to have_content(@merchant_2.state)

        click_link(@merchant_2.name)
      end

      expect(current_path).to eq("/admin/merchants/#{@merchant_2.id}")
    end

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

    it "When I click disable on a merchant all merchant's items are also disabled" do
      visit '/items'

      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@pull_toy.name)

      visit '/merchants'

      within "#merchant-#{@merchant_2.id}" do
        click_button('Disable')
      end

      visit '/items'

      expect(page).to_not have_content(@tire.name)
      expect(page).to_not have_content(@pull_toy.name)
    end

    it 'I see an enable button next to merchants who are currently disabled' do
      visit '/merchants'

      within "#merchant-#{@merchant_1.id}" do
        expect(page).to have_button('Disable')
        expect(page).to_not have_button('Enable')
      end

      within "#merchant-#{@merchant_2.id}" do
        expect(page).to have_button('Disable')
        expect(page).to_not have_button('Enable')
      end

      within "#merchant-#{@merchant_3.id}" do
        expect(page).to have_button('Enable')
        expect(page).to_not have_button('Disable')
      end
    end

    it 'I can click on the enable button and enable merchant account' do
      visit '/merchants'

      within "#merchant-#{@merchant_3.id}" do
        click_button('Enable')
        expect(current_path).to eq('/merchants')
      end

      expect(page).to have_content('Ahoy! This merchant has re-joined the ranks.')

      within "#merchant-#{@merchant_3.id}" do
        expect(page).to have_button('Disable')
      end
    end

    it "When I click enable on a merchant all merchant's items are also enabled" do
      visit '/items'

      expect(page).to_not have_content(@chain.name)
      expect(page).to_not have_content(@dog_bone.name)

      visit '/merchants'

      within "#merchant-#{@merchant_3.id}" do
        click_button('Enable')
      end

      visit '/items'

      expect(page).to have_content(@chain.name)
      expect(page).to have_content(@dog_bone.name)
    end
  end

  describe 'as a default user' do
    it 'I cannot see a disable button on merchants index' do
      default_user = create(:user, role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

      visit '/merchants'

      expect(page).to_not have_button('Disable')
    end

    it 'I cannot see an enable button on merchants index' do
      default_user = create(:user, role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

      visit '/merchants'

      expect(page).to_not have_button('Enable')
    end

    it 'I cannot link to the admin/merchant dashboard' do
      default_user = create(:user, role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

      visit '/merchants'

      within "#merchant-#{@merchant_2.id}" do
        click_link(@merchant_2.name)
      end

      expect(current_path).to_not eq("/admin/merchants/#{@merchant_2.id}")
      expect(current_path).to eq("/merchants/#{@merchant_2.id}")
    end
  end

  describe 'as a merchant user' do
    it 'I cannot see a disable button on merchants index' do
      default_user = create(:user, role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

      visit '/merchants'

      expect(page).to_not have_button('Disable')
    end

    it 'I cannot see an enable button on merchants index' do
      default_user = create(:user, role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)

      visit '/merchants'

      expect(page).to_not have_button('Enable')
    end
  end
end
