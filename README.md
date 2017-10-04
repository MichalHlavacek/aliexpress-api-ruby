[![Gem Version](https://badge.fury.io/rb/tophatter-merchant.svg)](https://badge.fury.io/rb/tophatter-merchant)
[![Build Status](https://travis-ci.org/tophatter/merchant-api-ruby.svg?branch=master)](https://travis-ci.org/tophatter/merchant-api-ruby)
[![Coverage Status](https://coveralls.io/repos/github/tophatter/merchant-api-ruby/badge.svg?branch=master)](https://coveralls.io/github/tophatter/merchant-api-ruby?branch=master)

### Tophatter Merchant API
Full documentation is available [here](https://tophatter.readme.io/v1/docs).

### Installation
```ruby
gem 'tophatter-merchant', require: 'aliexpress'
```

### Console Testing (Development)
```bash
echo http://tophatter.dev/merchant_api/v1 > .api_path
echo 293da6763df7cb3b894a1831addcb52d > .access_token
bin/console
```

### API Authentication
```ruby
AliExpress.access_token = <YOUR ACCESS TOKEN>
```

### Products

#### List the product definition.
```ruby
AliExpress::Product.schema
```

#### List all of the products in your inventory.
```ruby
AliExpress::Product.all(page: 1, per_page: 100)
```

#### Search for products.
```ruby
AliExpress::Product.search(query: 'Shirt', page: 1, per_page: 100)
```

#### Retrieve a specific product.
```ruby
AliExpress::Product.retrieve('WAH5282')
```

#### Create a product.
```ruby
AliExpress::Product.create(
  identifier: '6631A',
  category: 'Electronics|Hardware (Computers/Tablets/Phones)|Mobile',
  title: 'Apple iPhone 6S',
  description: 'This is the description.',
  condition: 'Refurbished - Manufacturer',
  starting_bid: 1,
  buy_now_price: 150,
  cost_basis: 75,
  shipping_price: 5.0,
  success_fee_bid: 0.5,
  shipping_origin: 'United States',
  weight: 6,
  days_to_fulfill: 3,
  days_to_deliver: 5,
  variations: {
    '6631A-WHITE': { identifier: '6631A-WHITE', color: 'White', quantity: 1 },
    '6631A-BLACK': { identifier: '6631A-BLACK', color: 'Black', quantity: 2 }
  },
  primary_image: 'https://d38eepresuu519.cloudfront.net/b2aa7d2708324f756ffee551ba43a74f/original.jpg',
  extra_images: 'https://d38eepresuu519.cloudfront.net/e615c55184c06f391dbd768f855904e6/original.jpg|https://d38eepresuu519.cloudfront.net/7cd125f0fa42c965675eabaf3309aa6d/original.jpg'
)
```

#### Update a product.
```ruby
AliExpress::Product.update('6631A', buy_now_price: 100)
```

#### Disable an enabled product.
```ruby
AliExpress::Product.disable('6631A')
```

#### Enable a disabled product.
```ruby
AliExpress::Product.enable('6631A')
```

### Variations

#### Retrieve a specific variation.
```ruby
AliExpress::Variation.retrieve('6631A-BLACK')
```

#### Create a variation.
```ruby
AliExpress::Variation.create(product_identifier: '6631A', identifier: '6631A-PINK', color: 'Pink', quantity: 33)
```

#### Update a variation.
```ruby
AliExpress::Variation.update('6631A-PINK', quantity: 999)
```

### Orders

#### List all orders.
```ruby
AliExpress::Order.all(filter: 'unfulfilled', page: 1, per_page: 100)
```

#### Retrieve a specific order.
```ruby
AliExpress::Order.retrieve(1035509247)
```

#### Fulfill an order.
```ruby
AliExpress::Order.fulfill(1035509247, carrier: 'USPS', tracking_number: '9400111899562173406594')
```

#### Refund the shipping fee for an order.
```ruby
AliExpress::Order.refund(1035509249, type: 'partial', reason: 'delay_in_shipping', fees: ['shipping_fee'])
```

#### Refund an order in full.
```ruby
AliExpress::Order.refund(1035509249, type: 'full', reason: 'out_of_stock')
```
