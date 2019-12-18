FactoryBot.define do
  factory :order do
    name { "Pirate Jack" }
    address { "123 Ocean Breeze" }
    city { "Bootytown" }
    state { "Turks & Caicos" }
    zip { "13375" }
  end

  factory :item do
    name { "Used Pirate Hook" }
    description { "Light wear and tear. Found in the belly of a crocodile." }
    price { '200' }
    image { 'https://smhttp-ssl-42830.nexcesscdn.net/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/f/w/fw9160.jpg' }
    inventory { '5000' }
    merchant
  end

  factory :item_order do
    price { 1 }
    quantity { 1 } 
    item
    order
  end
end
