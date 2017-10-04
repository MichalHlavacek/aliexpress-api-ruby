module AliExpress
  class Auth < Resource
    class << self
      def authorize
        oauth_client = client
        oauth_params = params
        oauth_signature = sign(oauth_params)
        url = oauth_client.authorize_url(oauth_params.merge(_aop_signature: oauth_signature))
        system('open', url) if RUBY_PLATFORM == 'x86_64-darwin16'
        puts "Open #{url} in your browser, and then enter the code below."
        print 'authorization_code> '
        authorization_code = gets
        token = oauth_client.get_token(
          code: authorization_code,
          grant_type: 'authorization_code',
          need_refresh_token: 'true',
          parse: :json,
          redirect_uri: redirect_uri
        ).to_hash
        puts "echo #{token[:access_token]} > .access_token"
        puts "echo #{token[:refresh_token]} > .refresh_token"
        token
      end

      def refresh
        if AliExpress.refresh_token
          response = post(
            "1/system.oauth2/getToken/#{AliExpress.app_key}",
            grant_type: 'refresh_token',
            client_id: AliExpress.client_id,
            client_secret: AliExpress.client_secret,
            refresh_token: AliExpress.refresh_token
          )
          AliExpress.access_token = response['access_token']
        else
          raise Exception, 'You must have a refresh_token to refresh authorization. You need to call `AliExpress::Auth.authorize` and follow the instructions to generate one.'
        end
      end

      private

      def redirect_uri
        'urn:ietf:wg:oauth:2.0:oob'
      end

      def client
        OAuth2::Client.new(
          AliExpress.client_id,
          AliExpress.client_secret,
          site: 'https://gw.api.alibaba.com',
          authorize_url: '/auth/authorize.htm',
          token_url: "/openapi/http/1/system.oauth2/getToken/#{AliExpress.client_id}"
        )
      end

      def params
        {
          client_id: AliExpress.client_id,
          redirect_uri: redirect_uri,
          site: 'aliexpress',
          state: SecureRandom.hex(24)
        }
      end

      def sign(hash)
        OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest.new('sha1'),
          AliExpress.client_secret,
          hash.sort.flatten.join.to_s
        ).upcase
      end
    end
  end
end
