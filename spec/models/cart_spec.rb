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
  end
end
