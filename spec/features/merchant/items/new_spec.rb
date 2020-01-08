require 'rails_helper'

RSpec.describe 'As a merchant', type: :feature do
  describe 'When I visit my items page' do
    before(:each) do
      merchant = create(:merchant)
      merchant_user = create(:user, role: 1, merchant_id: merchant.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

      visit "/merchant/items"
    end

    it 'I see a link to add a new item' do
      expect(page).to have_link('Add New Item')
    end

    describe 'When I click on the link to add a new item' do
      before(:each) do
        click_on('Add New Item')
      end

      it 'I am taken to the new item route and view' do
        expect(current_path).to eq('/merchant/items/new')
      end

      describe 'I see a form where I can add new information about an item, including:' do
        it 'the name of the item, which cannot be blank' do
          expect(page).to have_field('Name')
        end
        it 'a description for the item, which cannot be blank' do
          expect(page).to have_field('Description')
        end
        it 'a thumbnail image URL string, which CAN be left blank' do
          expect(page).to have_field('Thumbnail Image URL')
        end
        it 'a price which must be greater than $0.00' do
          expect(page).to have_field('Price')
        end
        it 'my current inventory count of this item which is 0 or greater' do
          expect(page).to have_field('Current Inventory Count')
        end
      end

      describe 'When I submit valid information and submit the form' do
        before(:each) do
          fill_in 'Name', with: 'Used Parrot'
          fill_in 'Description', with: 'Lightly used parrot, knows 4 sea shanties and only mild profanity.'
          fill_in 'Thumbnail Image URL', with: 'https://lafeber.com/pet-birds/wp-content/uploads/OrangeWing_Rio-241x300.jpg'
          fill_in 'Price', with: '20'
          fill_in 'Current Inventory Count', with: '1'
          click_on 'Create Item'
        end

        it 'I am taken back to my items page' do
          expect(current_path).to eq("/merchant/items")
        end

        it 'I see a flash message indicating my new item is saved' do
          expect(page).to have_content("Yer hold be brimming with booty! Er, yer item do be created.")
        end

        it 'I see the new item on the page, and it is enabled and available for sale' do
          within "#item-#{Item.last.id}" do
            expect(page).to have_link('Used Parrot')
            expect(page).to have_content('Lightly used parrot, knows 4 sea shanties and only mild profanity.')
            expect(page).to have_content('Price: $20.00')
            expect(page).to have_content('Inventory: 1')
            expect(page).to have_content('Active')
          end
        end

        it 'If I left the image field blank, I see a placeholder image for the thumbnail' do
          visit '/merchant/items/new'

          fill_in 'Name', with: 'Used Parrot'
          fill_in 'Description', with: 'Lightly used parrot, knows 4 sea shanties and only mild profanity.'
          fill_in 'Price', with: '20'
          fill_in 'Current Inventory Count', with: '1'

          click_on 'Create Item'

          within "#item-#{Item.last.id}" do
            expect(page).to have_css("img[src*='https://res.cloudinary.com/teepublic/image/private/s--jAfsTCc0--/t_Preview/b_rgb:42332c,c_limit,f_jpg,h_630,q_90,w_630/v1472219144/production/designs/651797_1.jpg']")
          end
        end
      end
    end
  end
end
