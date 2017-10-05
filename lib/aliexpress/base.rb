module AliExpress
  class Base
    include AliExpress

    class << self
      protected

      def protocol
        AliExpress.protocol
      end

      def host
        AliExpress.host
      end

      def base_uri
        AliExpress.base_uri
      end

      def client_id
        AliExpress.client_id
      end

      def client_secret
        AliExpress.client_secret
      end

      def access_token
        AliExpress.access_token
      end

      def refresh_token
        AliExpress.refresh_token
      end

      def currency
        AliExpress.currency
      end

      def language
        AliExpress.language
      end

      def logger
        AliExpress.logger
      end

      def get(params)
        request(params.merge(method: :get))
      end

      def post(params)
        request(params.merge(method: :post))
      end

      private

      def request(method:, protocol: 'param2', api_version: 1, api_namespace: 'aliexpress.open', api_call:, auth: true, sign: true, params: {})
        path = [protocol, api_version, api_namespace, api_call, client_id].join('/')

        payload = params
        payload[:access_token] = access_token if auth

        if sign
          signature_factor = path + payload.map { |key, value| "#{key}#{value}" }.sort.join
          payload[:_aop_signature] = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), client_secret, signature_factor).upcase
          logger.debug "signature_factor=#{signature_factor}, signature=#{payload[:_aop_signature]}"
        end

        url = [base_uri, path].join('/')

        resp = if method == :get
          unless params.length.zero?
            uri = Addressable::URI.new
            uri.query_values = params
            url += "?#{uri.query}"
          end

          logger.debug "GET #{url}"
          RestClient.get(url)
        else
          logger.debug "POST #{url} | #{payload}"
          RestClient.post(url, payload)
        end

        begin
          JSON.parse(resp.body)
        rescue JSON::ParserError
          resp.body
        end
      rescue RestClient::Exception => exception
        resp = begin
          JSON.parse(exception.response)
        rescue JSON::ParserError
          exception.response
        end

        logger.debug "#{exception.class.name} (#{exception.response.code}): #{resp.inspect}"
        resp
      end
    end
  end
end
