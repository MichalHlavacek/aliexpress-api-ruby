[![Build Status](https://travis-ci.org/tophatter/aliexpress-api-ruby.svg?branch=master)](https://travis-ci.org/tophatter/aliexpress-api-ruby)
[![Coverage Status](https://coveralls.io/repos/github/tophatter/aliexpress-api-ruby/badge.svg?branch=master)](https://coveralls.io/github/tophatter/aliexpress-api-ruby?branch=master)

### AliExpress SDK for Ruby:

#### Authentication:

To use this SDK, you must have an app key and app secret (a.k.a. client id and client secret). These can be obtained [here](https://portals.aliexpress.com/adcenter/apiSetting.htm) if you're using the affiliate program, or [here](http://isvus.aliexpress.com/isv/index.htm) if you're using the ISV API.

In the affiliate program API settings, you'll see the following:

![](https://i.imgur.com/ycMNgMY.png)

The "api key" is your client id, and the "digital signature" is your client secret.

The API uses OAuth for authentication. You need to first go through a manual authorization sequence to get a short-live authorization code. That code can be exchanged for an access token that last 10 hours, and a refresh token that lasts significantly longer.

Using this gem's console, you get obtain an access token as follows:

```
bash $ bin/console
[1] pry(main)> AliExpress.client_id = [YOUR CLIENT ID]
[2] pry(main)> AliExpress.client_secret = [YOUR CLIENT SECRET]
[3] pry(main)> AliExpress::Auth.authorize
Open https://gw.api.alibaba.com/auth/authorize.htm?_aop_signature=REDACTED&client_id=REDACTED&redirect_uri=REDACTED&site=aliexpress&state=REDACTED in your browser, and then enter the code below.
authorization_code> [ENTER YOUR CODE HERE]
{
    "refresh_token_timeout" => "20180402143144000-0700",
                    "aliId" => "[REDACTED]",
           "resource_owner" => "[REDACTED]",
              :access_token => "[REDACTED]",
             :refresh_token => "[REDACTED]",
                :expires_at => 1507194954
}
```

Once your tokens are obtained, you can instruct this SDK to use them:

```
AliExpress.access_token = [YOUR ACCESS TOKEN]
AliExpress.refresh_token = [YOUR REFRESH TOKEN]
```

If your access token expires, you can get a new one with the following:

```
AliExpress::Auth.refresh
```

#### Affiliate API:

##### api.listPromotionProduct

```
[1] pry(main)> AliExpress::Affiliate.list_promotion_product(keywords: 'drone')
D, [2017-10-05T11:23:03.971387 #69079] DEBUG -- : GET https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listPromotionProduct/[REDACTED]?fields=productId%2CproductTitle%2CproductUrl%2CimageUrl%2CallImageUrls%2CoriginalPrice%2CsalePrice%2ClocalPrice%2Cdiscount%2Cvolume%2CpackageType%2ClotNum%2CvalidTime&keywords=drone
[
    [ 0] {
               "lotNum" => 1,
          "packageType" => "piece",
             "imageUrl" => "https://ae01.alicdn.com/kf/HTB1nxEjSFXXXXcDXpXXq6xXFXXXF/100-Original-SYMA-X5C-Upgrade-Version-RC-font-b-Drone-b-font-With-2MP-HD-Camera.jpg",
         "allImageUrls" => "https://ae01.alicdn.com/kf/HTB1nxEjSFXXXXcDXpXXq6xXFXXXF/100-Original-SYMA-X5C-Upgrade-Version-RC-font-b-Drone-b-font-With-2MP-HD-Camera.jpg,https://ae01.alicdn.com/kf/HTB1O6LUSFXXXXX5aXXXq6xXFXXXB/100-Original-SYMA-X5C-Upgrade-Version-RC-font-b-Drone-b-font-With-2MP-HD-Camera.jpg,https://ae01.alicdn.com/kf/HTB1aA.DSFXXXXXgXXXXq6xXFXXX3/100-Original-SYMA-X5C-Upgrade-Version-RC-font-b-Drone-b-font-With-2MP-HD-Camera.jpg,https://ae01.alicdn.com/kf/HTB1N.kySFXXXXaUXXXXq6xXFXXXF/100-Original-SYMA-X5C-Upgrade-Version-RC-font-b-Drone-b-font-With-2MP-HD-Camera.jpg,https://ae01.alicdn.com/kf/HTB1lc_1SFXXXXcgXVXXq6xXFXXX9/100-Original-SYMA-X5C-Upgrade-Version-RC-font-b-Drone-b-font-With-2MP-HD-Camera.jpg,https://ae01.alicdn.com/kf/HTB16lEkSFXXXXcpXpXXq6xXFXXXK/100-Original-SYMA-X5C-Upgrade-Version-RC-font-b-Drone-b-font-With-2MP-HD-Camera.jpg",
            "productId" => 32817202058,
             "discount" => "5%",
        "originalPrice" => "US $27.99",
         "productTitle" => "100% Original SYMA X5C (Upgrade Version) RC <font><b>Drone</b></font> With 2MP HD Camera 6-Axis RC Quadcopter Helicopter X5 Dron Without Camera",
            "validTime" => "2017-10-08",
           "productUrl" => "https://www.aliexpress.com/item/SYMA-X5C-1-Upgrade-Version-SYMA-X5C-Professional-RC-Drone-6-Axis-Helicopter-Quadcopter-With-2MP/32817202058.html",
               "volume" => "14",
            "salePrice" => "US $26.59"
    },
    <snip>
```

##### api.getPromotionProductDetail

```
[1] pry(main)> AliExpress::Affiliate.get_promotion_product_detail(32817202058)
D, [2017-10-05T11:24:19.235970 #69079] DEBUG -- : GET https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionProductDetail/[REDACTED]?fields=productId%2CproductTitle%2CproductUrl%2CimageUrl%2CallImageUrls%2CoriginalPrice%2CsalePrice%2ClocalPrice%2Cdiscount%2Cvolume%2CpackageType%2ClotNum%2CvalidTime&productId=32817202058
{
           "lotNum" => 1,
      "packageType" => "piece",
         "imageUrl" => "https://ae01.alicdn.com/kf/HTB1nxEjSFXXXXcDXpXXq6xXFXXXF/100-Original-SYMA-X5C-Upgrade-Version-RC-Drone-With-2MP-HD-Camera-6-Axis-RC-Quadcopter.jpg",
     "allImageUrls" => "https://ae01.alicdn.com/kf/HTB1nxEjSFXXXXcDXpXXq6xXFXXXF/100-Original-SYMA-X5C-Upgrade-Version-RC-Drone-With-2MP-HD-Camera-6-Axis-RC-Quadcopter.jpg,https://ae01.alicdn.com/kf/HTB1O6LUSFXXXXX5aXXXq6xXFXXXB/100-Original-SYMA-X5C-Upgrade-Version-RC-Drone-With-2MP-HD-Camera-6-Axis-RC-Quadcopter.jpg,https://ae01.alicdn.com/kf/HTB1aA.DSFXXXXXgXXXXq6xXFXXX3/100-Original-SYMA-X5C-Upgrade-Version-RC-Drone-With-2MP-HD-Camera-6-Axis-RC-Quadcopter.jpg,https://ae01.alicdn.com/kf/HTB1N.kySFXXXXaUXXXXq6xXFXXXF/100-Original-SYMA-X5C-Upgrade-Version-RC-Drone-With-2MP-HD-Camera-6-Axis-RC-Quadcopter.jpg,https://ae01.alicdn.com/kf/HTB1lc_1SFXXXXcgXVXXq6xXFXXX9/100-Original-SYMA-X5C-Upgrade-Version-RC-Drone-With-2MP-HD-Camera-6-Axis-RC-Quadcopter.jpg,https://ae01.alicdn.com/kf/HTB16lEkSFXXXXcpXpXXq6xXFXXXK/100-Original-SYMA-X5C-Upgrade-Version-RC-Drone-With-2MP-HD-Camera-6-Axis-RC-Quadcopter.jpg",
        "productId" => 32817202058,
         "discount" => "5%",
    "originalPrice" => "US $27.99",
     "productTitle" => "100% Original SYMA X5C (Upgrade Version) RC Drone With 2MP HD Camera 6-Axis RC Quadcopter Helicopter X5 Dron Without Camera",
        "validTime" => "2017-10-08",
       "productUrl" => "https://www.aliexpress.com/item/SYMA-X5C-1-Upgrade-Version-SYMA-X5C-Professional-RC-Drone-6-Axis-Helicopter-Quadcopter-With-2MP/32817202058.html",
           "volume" => "14",
        "salePrice" => "US $26.59"
}
```

##### api.listHotProducts

```
[1] pry(main)> AliExpress::Affiliate.list_hot_products(3)
D, [2017-10-05T11:21:54.835675 #68982] DEBUG -- : GET https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listHotProducts/[REDACTED]?categoryId=3&language=en&localCurrency=USD
[
    [ 0] {
          "localPrice" => "21.00 $",
            "imageUrl" => "https://ae01.alicdn.com/kf/HTB1YsQwQFXXXXcvXpXXq6xXFXXX0/Preself-Hoodies-Sweatshirt-Women-Casual-Outwear-Hoody-Loose-Long-Sleeve-Mantle-Hooded-Cover-Pullover-Clothes-2017.jpg",
          "productUrl" => "https://www.aliexpress.com/item/New-Women-Loose-Fashion-Autumn-Winter-Hooded-Oversize-Sweatshirt-Coat-Outwear/32763830156.html",
           "validTime" => "2017-10-18",
        "productTitle" => "Preself Hoodies Sweatshirt Women Casual Outwear Hoody Loose Long Sleeve Mantle Hooded Cover Pullover Clothes 2017 New",
              "volume" => "",
           "salePrice" => "US $21.00",
           "productId" => 32763830156
    },
    <snip>
```

#### ISV API:

In progress.
