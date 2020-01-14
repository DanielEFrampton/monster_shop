require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe 'class methods' do
    before(:each) do
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

    it 'return number of most ordered items sorted descending' do
      expected_association = Item.find([@item_order_1.item.id,
                                        @item_order_2.item.id,
                                        @item_order_3.item.id,
                                        @item_order_4.item.id,
                                        @item_order_5.item.id])
      expect(Item.most_popular(5)).to eq(expected_association)
    end

    it 'return number of least ordered items sorted ascending' do
      expected_association = Item.find([@item_order_11.item.id,
                                        @item_order_10.item.id,
                                        @item_order_9.item.id,
                                        @item_order_8.item.id,
                                        @item_order_7.item.id])
      expect(Item.least_popular(5)).to eq(expected_association)
    end
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
      @item_order_1 = create(:item_order, quantity: 11)
      @item_order_2 = create(:item_order, quantity: 6)
    end

    it 'return total number ordered of item' do
      expect(@item_order_1.item.quantity_ordered).to eq(11)
      expect(@item_order_2.item.quantity_ordered).to eq(6)
      expect(@chain.quantity_ordered).to eq(0)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      user = create(:user)
      order = user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    describe 'discounted_price' do
      it 'returns price reduced by given number used as percentage off' do
        item_2 = create(:item, price: 145)
        item_3 = create(:item, price: 35)

        expect(@chain.discounted_price(50)).to eq(25)
        expect(item_2.discounted_price(100)).to eq(0)
        expect(item_3.discounted_price(0)).to eq(35)
      end
    end
  end
end
