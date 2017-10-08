module AliExpress
  class Affiliate < Base
    CATEGORIES = {
      'Apparel & Accessories' => 3,
      'Automobiles & Motorcycles' => 34,
      'Beauty & Health' => 66,
      'Books for Local Russian' => 200004360,
      'Computer & Office' => 7,
      'Home Improvement' => 13,
      'Consumer Electronics' => 44,
      'Electrical Equipment & Supplies' => 5,
      'Electronic Components & Supplies' => 502,
      'Food' => 2,
      'Furniture' => 1503,
      'Hair & Accessories' => 200003655,
      'Hardware' => 42,
      'Home & Garden' => 15,
      'Home Appliances' => 6,
      'Industry & Business' => 200001996,
      'Jewelry & Accessories' => 36,
      'Lights & Lighting' => 39,
      'Luggage & Bags' => 1524,
      'Mother & Kids' => 1501,
      'Office & School Supplies' => 21,
      'Phones & Telecommunications' => 509,
      'Security & Protection' => 30,
      'Shoes' => 322,
      'Special Category' => 200001075,
      'Sports & Entertainment' => 18,
      'Tools' => 1420,
      'Toys & Hobbies' => 26,
      'Travel and Coupon Services' => 200003498,
      'Watches' => 1511,
      'Weddings & Events' => 320
    }.freeze

    FILTERS = %w(category keywords min_price max_price high_quality).freeze
    SORTS   = %w(orignalPriceUp orignalPriceDown sellerRateUp sellerRateDown).freeze
    FIELDS  = %w(productId productTitle productUrl imageUrl allImageUrls originalPrice salePrice localPrice discount volume).freeze

    SUCCESS = 20010000
    ERRORS  = {
      20020000 => 'System error.',
      20030000 => 'Unauthorized transfer request.',
      20030010 => 'Required parameters.',
      20030020 => 'Invalid protocol format.',
      20030030 => 'API version input parameter error.',
      20030040 => 'API namespace input parameter error.',
      20030050 => 'API name input parameter error.',
      20030060 => 'Fields input parameter error.',
      20030070 => 'Keyword input parameter error.',
      20030080 => 'Category ID input parameter error.',
      20030140 => 'Page number input parameter error.',
      20030150 => 'Page size input parameter error (default = 20, max = 40).',
      20030160 => 'Sort input parameter error.'
    }.freeze

    class << self
      def search(query:, filters: {}, sort: 'orignalPriceUp', page: nil, per_page: 40, fields: FIELDS)
        response = get(
          api_call: 'api.listPromotionProduct',
          params: {
            keywords: query,
            # filters
            categoryId: CATEGORIES[filters[:category]] || filters[:category],
            originalPriceFrom: filters[:min_price],
            originalPriceTo: filters[:max_price],
            highQualityItems: filters[:high_quality],
            # sorting
            sort: sort,
            # paging
            pageNo: page,
            pageSize: per_page,
            # response format
            fields: fields.join(',')
          }.delete_if { |_k, v| v.nil? }
        )

        raise_response_error(response) unless response['errorCode'] == SUCCESS
        response
      end

      def find(id, fields: FIELDS)
        response = get(
          api_call: 'api.getPromotionProductDetail',
          params: { productId: id, fields: fields.join(',') }
        )

        raise_response_error(response) unless response['errorCode'] == SUCCESS
        response
      end

      def similar(id)
        response = get(
          api_call: 'api.listSimilarProducts',
          params: { productId: id }
        )

        raise_response_error(response) unless response['errorCode'] == SUCCESS
        response
      end

      def popular(category)
        response = get(
          api_call: 'api.listHotProducts',
          params: { categoryId: CATEGORIES[category] || category }
        )

        raise_response_error(response) unless response['errorCode'] == SUCCESS
        response
      end

      private

      def get(hash)
        defaults = {
          api_namespace: 'portals.open',
          api_version: 2,
          auth: false,
          sign: false,
          params: {
            localCurrency: currency,
            language: language
          }
        }
        params = defaults[:params].merge(hash.delete(:params))
        super(defaults.merge(hash).merge(params: params))
      end

      def raise_response_error(response)
        exception = ResponseError.new(
          code: response['error_code'] || response['errorCode'],
          message: response['error_message'] || ERRORS[response['errorCode']] || response['errorCode'],
          response: response
        )

        raise exception
      end
    end
  end
end
