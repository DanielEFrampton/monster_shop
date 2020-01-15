# Monster Shop Solo

## [Live Site (Heroku Deployment)](http://monster-shop-solo.herokuapp.com/)

## Solo Project Description

Monster Shop Solo is a single-developer extension by Daniel Frampton of the previous [Monster Shop group project](https://github.com/philjdelong/monster_shop_part_1) he contributed toward. The extension focused primarily on implementing coupon codes, which can be managed by users with Merchant-level authorization and then input by default-level users at checkout.

### Project Requirements (100% Complete)

#### General Goals

Merchant users can generate coupon codes within the system.

#### Completion Criteria

1. Merchant users have a link on their dashboard to manage their coupons.
1. Merchant users have full CRUD functionality over their coupons with exceptions mentioned below:
   - merchant users cannot delete a coupon that has been used in an order
   - Note: Coupons cannot be for greater than 100% off.

1. A coupon will have a coupon name, a coupon code, and a percent-off value. The name and coupon code must be unique in the whole database.
1. Users need a way to add a coupon code when checking out. Only one coupon may be used per order.
1. A coupon code from a merchant only applies to items sold by that merchant.

#### Implementation Guidelines

1. If a user adds a coupon code, they can continue shopping. The coupon code is still remembered when returning to the cart page. (This information should not be stored in the database until after checkout. )
1. The cart show page should calculate subtotals and the grand total as usual, but also show a "discounted total".
1. Users can enter different coupon codes until they finish checking out, then the last code entered before clicking checkout is final.
1. Order show pages should display which coupon was used, as well as the discounted price.

#### Extensions (Completed)
1. Coupons can be used by multiple users, but may only be used one time per user.
1. Merchant users can enable/disable coupon codes
1. Merchant users can have a maximum of 5 coupons in the system

#### Learning Goals Reflected:

- Database relationships and migrations
- ActiveRecord
- Software Testing
- HTML/CSS layout and styling

# Original Monster Shop Group Project

## [Heroku Deployment](http://monster-shop-solo.herokuapp.com/)
## [Github Repo](https://github.com/philjdelong/monster_shop_part_1)

## Original Dev Team

### [Daniel Frampton](https://github.com/DanielEFrampton)
### [Melissa Robbins](https://github.com/mel-rob)
### [Phillip DeLong](https://github.com/philjdelong)
### [De'Marcus Kirby](https://github.com/DanielEFrampton)

## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will automatically set the order status to "shipped". Each user role will have access to some or all CRUD functionality for application models.

## Schema
<img width="702" alt="Screen Shot 2020-01-08 at 11 51 20 AM" src="https://user-images.githubusercontent.com/36940278/72007001-ad9cf400-3248-11ea-9f22-cc9f790f3d3a.png">

## User Roles
<img width="368" alt="Screen Shot 2020-01-09 at 12 56 08 PM" src="https://user-images.githubusercontent.com/36940278/72100203-1902c680-331a-11ea-84de-18d284cdefda.png">

- Visitor - this type of user is anonymously browsing our site and is not logged in
Regular User - this user is registered and logged in to the application while performing their work; can place items in a cart and create an order
- Merchant - this user works for a merchant and can fulfill orders, create/update/delete items, and update merchant information. They also have the same permissions as a regular user (adding items to a cart and checking out)
- Admin User - a registered user who has "superuser" access to all areas of the application; user is logged in to perform their work

### User Example Accounts

- Admin
```
  Email: admin@treasuretrove.com
  Password: admin
```
- Merchant
```
  Email: merchant@treasuretrove.com
  Password: merchant
```
- Default User
    - Click on Register and follow instructions to create an account

## Local Deployment
Follow these instructions in your -nix command line terminal:

Clone this repo:
```
  git clone git@github.com:philjdelong/monster_shop_part_1.git
```
Install required gems:
```
  bundle install
  bundle update
```
Start the database:
```
  rails db:{create,migrate,seed}
```
To run test suite and view test coverage:
```
  rspec
  open coverage/index.html
```
Start the Rails server:
```
  rails s
```
In your browser, navigate to localhost:3000.

## Resources Used

Wallpaper:
- https://hipwallpaper.com/treasure-backgrounds/

Fonts:
- IM Fell - https://fonts.google.com/specimen/IM+Fell+English
- Princess Sofia - https://fonts.google.com/specimen/Princess+Sofia


## Learning Goals
 - One-to-Many, Many-to-Many Relationships
 - Schema Design
 - Authentication & Authorization
    - Limit functionality to authorized users based on User Role
    - BCrypt for hashing user passwords
    - Namespaced Routes
 - ActiveRecord
    - Join Multiple tables of data
    - Calculate statistics
    - Create Collections of Data grouped by one or more attributes
 - Login/Logout Functionality
    - Store some user information in Sessions
 - Rails
    - Utilize Partials to DRY up code
    - Use filters in Rails controllers

## Screenshots

### Homepage
<img width="1440" alt="Screen Shot 2020-01-08 at 11 35 57 AM" src="https://user-images.githubusercontent.com/36940278/72099493-a218fe00-3318-11ea-97ac-658a3f9b93b9.png">

### Item Show Page
<img width="1437" alt="Screen Shot 2020-01-09 at 11 11 50 AM" src="https://user-images.githubusercontent.com/36940278/72099696-09cf4900-3319-11ea-8612-faa37349fb7e.png">

### Cart Confirmation
<img width="1440" alt="Screen Shot 2020-01-09 at 12 47 41 PM" src="https://user-images.githubusercontent.com/36940278/72099639-ec01e400-3318-11ea-8cd4-efad5c2ac1d1.png">

### Cart
<img width="1438" alt="Screen Shot 2020-01-09 at 12 59 51 PM" src="https://user-images.githubusercontent.com/36940278/72100485-a0e8d080-331a-11ea-9bad-bc3de3c48e5b.png">

### Mechant Show Page
<img width="1439" alt="Screen Shot 2020-01-09 at 11 17 37 AM" src="https://user-images.githubusercontent.com/36940278/72099717-1bb0ec00-3319-11ea-84d8-cf0af5992085.png">

## Order Status

1. 'pending' means a user has placed items in a cart and "checked out" to create an order, merchants may or may not have fulfilled any items yet
2. 'packaged' means all merchants have fulfilled their items for the order, and has been packaged and ready to ship
3. 'shipped' means an admin has 'shipped' a package and can no longer be cancelled by a user
4. 'cancelled' - only 'pending' and 'packaged' orders can be cancelled
