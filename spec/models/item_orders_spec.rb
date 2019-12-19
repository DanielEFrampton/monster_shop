require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'instance methods' do
    it 'subtotal' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      user = create(:user)
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(200)
    end
  end

  describe 'after_update' do
    describe 'set_order_packaged' do
      it 'changes status of associated order to packaged if all item_orders fulfilled' do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1)

        merchant_2 = create(:merchant)
        item_3 = create(:item, merchant: merchant_2)

        user_1 = create(:user)
        order_1 = create(:order, user: user_1)
        item_order_1 = order_1.item_orders.create!(item: item_1, order: order_1, price: item_1.price, quantity: 2)
        item_order_2 = order_1.item_orders.create!(item: item_2, order: order_1, price: item_2.price, quantity: 1)

        user_2 = create(:user)
        order_2 = create(:order, user: user_2)
        item_order_3 = order_2.item_orders.create!(item: item_2, price: item_2.price, quantity: 1)

        expect(order_1.status).to eq('pending')
        item_order_1.update(fulfilled: true)
        expect(order_1.status).to eq('pending')
        item_order_2.update(fulfilled: true)
        expect(order_1.status).to eq('packaged')

        expect(order_2.status).to eq('pending')
        item_order_3.update(fulfilled: true)
        expect(order_2.status).to eq('packaged')
      end
    end
  end
end
