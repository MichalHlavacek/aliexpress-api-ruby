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
    end
  end
end
