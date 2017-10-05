module AliExpress
  class Product < Base
    class << self
      def find(id)
        post(api_call: 'api.findAeProductById', params: { productId: id })
      end

      private

      def get(params)
        super(default_params.merge(params))
      end

      def default_params
        {
          api_namespace: 'aliexpress.open',
          api_version: 1
        }
      end
    end
  end
end
