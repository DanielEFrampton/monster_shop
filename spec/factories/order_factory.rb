FactoryBot.define do
  factory :order do
    name { "Pirate Jack" }
    address { "123 Ocean Breeze" }
    city { "Bootytown" }
    state { "Turks & Caicos" }
    zip { "13375" }
    user
    coupon_id { nil }
  end
end
