FactoryBot.define do
  sequence :email do |n|
    "pirate#{n}@ethecarribean.com"
  end

  factory :user do
    name { "Pirate Jack" }
    address { "123 Ocean Breeze" }
    city { "Bootytown" }
    state { "Turks & Caicos" }
    zip { "13375" }
    email
    password { "landlubberssuck" }
    password_confirmation { "landlubberssuck" }
    role { 0 }
    merchant_id { nil }
  end
end
