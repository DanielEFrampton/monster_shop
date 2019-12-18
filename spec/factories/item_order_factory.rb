FactoryBot.define do
  factory :item_order do
    price { 1 }
    quantity { 1 }
    item
    order
  end
end
