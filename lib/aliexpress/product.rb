module AliExpress
  class Product < Resource
    class << self
      def find(id)
        post(
          api_call: 'api.findAeProductById',
          api_namespace: 'aliexpress.open',
          api_version: 1,
          params: {
            productId: id
          }
        )
      end

      # The list of categories can be found here:
      # https://portals.aliexpress.com/help/help_center_API.html
      def hot(category_id)
        response = get(
          api_call: 'api.listHotProducts',
          api_namespace: 'portals.open',
          api_version: 2,
          params: {
            localCurrency: currency,
            language: language,
            categoryId: category_id
          }
        )

        if response['errorCode'] == 20010000
          if response.key?('result')
            response['result']['products']
          else
            []
          end
        else
          # Show error message.
          []
        end
      end
    end
  end
end
