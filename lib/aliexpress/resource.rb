module AliExpress
  class Resource
    include ActiveModel::Model

    def initialize(hash)
      self.attributes = hash
    end

    def attributes
      self.class.attributes
    end

    def attributes=(hash)
      # Only honor valid attributes.
      hash.each do |key, value|
        if respond_to?("#{key}=")
          send("#{key}=", value)
        else
          AliExpress.logger.warn "Invalid attribute #{key} specified for #{self.class.name}"
        end
      end
    end

    def persisted?
      id.present? # @TODO: Should this be internal_id?
    end

    def to_h
      self.class.attributes.map { |key| [key, send(key)] }.to_h
    end

    class << self
      def attr_accessor(*vars)
        @attributes ||= {}
        vars.each { |var| @attributes[var.to_s] = true }
        super(*vars)
      end

      def attributes
        @attributes ||= {}
        @attributes.keys
      end

      # protected

      def get(path, params = {})
        execute request(method: :get, path: path, params: params)
      end

      def post(path, params = {})
        execute request(method: :post, path: path, params: params)
      end

      def put(path, params = {})
        execute request(method: :put, path: path, params: params)
      end

      def delete(path, params = {})
        execute request(method: :delete, path: path, params: params)
      end

      def execute(request)
        AliExpress.logger.debug "#{request.method.upcase} #{request.url}#{request.payload ? nil : " - #{request.payload.inspect}"}"
        response = request.execute
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError
          response.body
        end
      rescue RestClient::Exception => exception
        response = begin
          JSON.parse(exception.response)
        rescue JSON::ParserError
          exception.response
        end
        AliExpress.logger.debug "#{exception.class.name} (#{exception.response.code}): #{response.inspect}"
        response
      end

      def sign(signature_factor)
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), AliExpress.app_secret, signature_factor).upcase
      end

      def request(method:, path:, params: {}, accept: :json)
        # payload = if AliExpress.access_token.present?
        #   params.merge(access_token: AliExpress.access_token)
        # else
        #   params
        # end

        url = if path[0, 4] == 'http'
          path
        else
          "#{AliExpress.api_path}/#{path}"
        end

        payload = nil

        if method == :get
          signature_factor = url.clone
          signature_factor << params.map { |k, v| "#{k}#{v}" }.sort.join
          params[:_aop_signature] = sign(signature_factor)
          uri = Addressable::URI.new
          uri.query_values = params
          url = "#{url}?#{uri.query}"
        else
          payload = params
        end

        RestClient::Request.new(method: method, url: url, payload: payload, accept: accept)
      end
    end
  end
end
