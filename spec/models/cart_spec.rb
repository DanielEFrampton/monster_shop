require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'instance methods' do
    describe 'add_quantity' do
      it 'increments quantity of item in cart by one' do
        item = create(:item)
        cart = Cart.new({item.id => 1})

        cart.add_quantity(item.id)

        expect(cart.contents[item.id]).to eq(2)
      end
    end

    describe 'subtract_quantity' do
      it 'decrements quantity of item in cart by one' do
        item = create(:item)
        cart = Cart.new({item.id => 5})

        cart.subtract_quantity(item.id)

        expect(cart.contents[item.id]).to eq(4)
      end
    end

    describe 'limit_reached?' do
      it 'checks if item quantity in cart is equal to item inventory' do
        item = create(:item, inventory: 5)
        cart = Cart.new({item.id.to_s => 4})

        expect(cart.contents[item.id.to_s]).to eq(4)
        expect(cart.limit_reached?(item.id.to_s)).to eq(false)

        cart.add_quantity(item.id.to_s)

        expect(cart.contents[item.id.to_s]).to eq(5)
        expect(cart.limit_reached?(item.id.to_s)).to eq(true)
      end
    end

    describe 'quantity_zero?' do
      it 'checks if quantity of item in cart is zero' do
        item = create(:item, inventory: 5)
        cart = Cart.new({item.id => 1})

        expect(cart.contents[item.id]).to eq(1)
        expect(cart.quantity_zero?(item.id)).to eq(false)

        cart.subtract_quantity(item.id)

        expect(cart.contents[item.id]).to eq(0)
        expect(cart.quantity_zero?(item.id)).to eq(true)
      end
    end

    describe 'discounted_total' do
      it 'calculates total price of cart after applying current coupon' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        item_1 = create(:item, merchant_id: merchant_1.id, price: 20)
        item_2 = create(:item, merchant_id: merchant_2.id, price: 10)
        coupon = item_1.merchant.coupons.create(name: 'Test Coupon', code: 'ABC123', percent_off: 50)
        cart = Cart.new({item_1.id => 1, item_2.id => 2}, coupon.id)

        expect(cart.discounted_total).to eq(30)
      end
    end

    describe 'discounted_price' do
      it 'calculates price of individual item with coupon accounted for' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        item_1 = create(:item, merchant_id: merchant_1.id, price: 20)
        item_2 = create(:item, merchant_id: merchant_2.id, price: 10)
        coupon = item_1.merchant.coupons.create(name: 'Test Coupon', code: 'ABC123', percent_off: 50)
        cart = Cart.new({item_1.id => 1, item_2.id => 2}, coupon.id)

        expect(cart.discounted_price(item_1)).to eq(10)
      end
    end

    describe 'discounted_subtotal' do
      it 'calculates subtotal of individual item with coupon accounted for' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        item_1 = create(:item, merchant_id: merchant_1.id, price: 20)
        item_2 = create(:item, merchant_id: merchant_2.id, price: 10)
        coupon = item_1.merchant.coupons.create(name: 'Test Coupon', code: 'ABC123', percent_off: 50)
        cart = Cart.new({item_1.id.to_s => 3, item_2.id.to_s => 2}, coupon.id)

        expect(cart.discounted_subtotal(item_1)).to eq(30)
      end
    end
  end
end
