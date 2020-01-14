require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it { should have_many :item_orders }
    it { should have_many(:items).through(:item_orders) }
    it { should belong_to :user }
    it { should belong_to(:coupon).optional }
  end

  describe 'statuses' do
    it 'can be pending' do
      order = create(:order, status: 0)

      expect(order.status).to eq('pending')
      expect(order.pending?).to be_truthy
    end

    it 'can be packaged' do
      order = create(:order, status: 1)

      expect(order.status).to eq('packaged')
      expect(order.packaged?).to be_truthy
    end

    it 'can be shipped' do
      order = create(:order, status: 2)

      expect(order.status).to eq('shipped')
      expect(order.shipped?).to be_truthy
    end

    it 'can be cancelled' do
      order = create(:order, status: 3)

      expect(order.status).to eq('cancelled')
      expect(order.cancelled?).to be_truthy
    end
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @user = create(:user)
      @employee = create(:user, role: 1, merchant_id: @meg.id)


      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'total_quantity' do
      expect(@order_1.total_quantity).to eq(5)
    end

    it 'item_count_for_merchant' do
      expect(@order_1.item_count_for_merchant(@employee.merchant_id)).to eq(2)
    end

    it 'grand_total_for_merchant' do
      expect(@order_1.grand_total_for_merchant(@employee.merchant_id)).to eq(200)
    end
  end
end
