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
  end
end
