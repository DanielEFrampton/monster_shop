# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all
User.destroy_all

# ready-made admin account for testing
admin = User.create(name: "Captain Redbeard",
  address: "123 Ocean Breeze",
  city: "Bootytown",
  state: "Turks & Caicos",
  zip: "13375",
  email: 'admin@treasuretrove.com',
  password: "admin",
  password_confirmation: "admin",
  role: 2)

  #merchants
  bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
  dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

merchant_user = User.create(name: "Admiral Redbeard",
  address: "123 Ocean Breeze",
  city: "Bootytown",
  state: "Turks & Caicos",
  zip: "13375",
  email: 'merchant@treasuretrove.com',
  password: "merchant",
  password_confirmation: "merchant",
  merchant_id: bike_shop.id,
  role: 1)

#merchants
pollys_exotic_pets = Merchant.create(name: "Polly's Exotic Pets", address: '342 Ocean Breeze', city: 'Bootytown', state: 'Arrrrrkansas', zip: 80203)
peglegs_pirate_supply = Merchant.create(name: "Pegleg's Pirate Supply", address: '763 Blazing Way', city: 'Ember', state: 'Volcano Island', zip: 80210)

#pollys_exotic_pets items
marcel = pollys_exotic_pets.items.create(name: "Marcel", description: "Young and well-behaved capuchin monkey. Skilled at thievary and creating distraction. Looking for a loyal companion and adventurous partner-in-crime.", price: 250, image: "https://www.rainforest-alliance.org/sites/default/files/styles/750w_585h/public/2016-09/capuchin-monkey-baby.jpg?itok=4uOxFicS", inventory: 1)
iago = pollys_exotic_pets.items.create(name: "Iago", description: "Middle-aged scarlet macaw. Fairly well-trained. Speaks 3 languages and familiar with 2 pirate-based dialects. Best suited for ship life.", price: 350, image: "https://featuredcreature.com/wp-content/uploads/2013/03/scarlet-macaw.jpg", inventory: 1)
plague_infected_rats = pollys_exotic_pets.items.create(name: "Assorted Rats", description: "Assorted 1-yr-old rats infected with pneumonic plague bacteria. Perfect for creating filthy and hazardous conditions within an enemy's home or ship.", price: 100, image: "https://thumbs-prod.si-cdn.com/DHoIyetxnJy2qJzmPSBiCIxclAw=/420x240/https://public-media.si-cdn.com/filer/d9/5c/d95cb167-c04e-4687-9b1b-12344c2adb46/27053881679_75c7cd5fcd_k.jpg", inventory: 13)

#peglegs_pirate_supply items
classic_pirate_hooks = peglegs_pirate_supply.items.create(name: "Classic Pirate Hooks", description: "Detailed iron hooks with leather detail and excellent quality. One size fits all. Suitable for the left or right.", price: 55, image: "https://i.etsystatic.com/18476426/c/2078/1651/79/0/il/25e48f/2041284127/il_340x270.2041284127_ix7b.jpg", inventory: 32)
sill_eye_patches = peglegs_pirate_supply.items.create(name: "Silk Eye Patches", description: "Superb feel. The ladies love 'em. You'll forget you even lost an eye.", price: 21, image: "https://cdn2.bigcommerce.com/server2700/obcuok9/products/338/images/8859/362xl__85092.1403126477.1280.1280.jpg?c=2", inventory: 21)
