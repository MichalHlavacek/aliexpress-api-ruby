module AliExpress
  class Affiliate < Base
    CATEGORIES = {
      'Apparel & Accessories': 3,
      'Automobiles & Motorcycles': 34,
      'Beauty & Health': 66,
      'Books for Local Russian': 200004360,
      'Computer & Office': 7,
      'Home Improvement': 13,
      'Consumer Electronics': 44,
      'Electrical Equipment & Supplies': 5,
      'Electronic Components & Supplies': 502,
      'Food': 2,
      'Furniture': 1503,
      'Hair & Accessories': 200003655,
      'Hardware': 42,
      'Home & Garden': 15,
      'Home Appliances': 6,
      'Industry & Business': 200001996,
      'Jewelry & Accessories': 36,
      'Lights & Lighting': 39,
      'Luggage & Bags': 1524,
      'Mother & Kids': 1501,
      'Office & School Supplies': 21,
      'Phones & Telecommunications': 509,
      'Security & Protection': 30,
      'Shoes': 322,
      'Special Category': 200001075,
      'Sports & Entertainment': 18,
      'Tools': 1420,
      'Toys & Hobbies': 26,
      'Travel and Coupon Services': 200003498,
      'Watches': 1511,
      'Weddings & Events': 320
    }.freeze

    ERRORS = {
      20030120 => 'Discount input parameter error.'
    }.freeze

    FIELDS = %w(
      productId
      productTitle
      productUrl
      imageUrl
      allImageUrls
      originalPrice
      salePrice
      localPrice
      discount
      volume
      packageType
      lotNum
      validTime
    ).freeze

    class << self
      def list_promotion_product(keywords:, fields: FIELDS)
        response = get(
          api_call: 'api.listPromotionProduct',
          params: {
            keywords: keywords,
            fields: fields.join(',')
          }
        )

        if (error_code = response['errorCode']) == 20010000
          response.key?('result') ? response['result']['products'] : []
        else
          raise ERRORS[error_code]
        end
      end

      def get_promotion_product_detail(id, fields: FIELDS)
        response = get(
          api_call: 'api.getPromotionProductDetail',
          params: {
            productId: id,
            fields: fields.join(',')
          }
        )

        if (error_code = response['errorCode']) == 20010000
          response['result'] || {}
        else
          raise ERRORS[error_code]
        end
      end

      # The list of categories can be found here:
      # https://portals.aliexpress.com/help/help_center_API.html
      def list_hot_products(category_id)
        response = get(
          api_call: 'api.listHotProducts',
          params: {
            localCurrency: currency,
            language: language,
            categoryId: category_id
          }
        )

        if (error_code = response['errorCode']) == 20010000
          response.key?('result') ? response['result']['products'] : []
        else
          raise ERRORS[error_code]
        end
      end

      private

      def get(params)
        super(default_params.merge(params))
      end

      def default_params
        {
          api_namespace: 'portals.open',
          api_version: 2,
          auth: false,
          sign: false
        }
      end
    end
  end
end
