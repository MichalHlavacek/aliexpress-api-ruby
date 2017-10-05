module AliExpress
  class Auth < Base
    class << self
      def authorize(state = nil)
        oauth_client = client
        oauth_params = params(state || SecureRandom.hex(24))
        oauth_params[:_aop_signature] = sign(oauth_params)
        logger.debug oauth_params
        url = oauth_client.authorize_url(oauth_params)

        if RUBY_PLATFORM == 'x86_64-darwin16'
          begin
            system('open', url)
          rescue Exception => e # rubocop:disable Lint/RescueException
            logger.debug "Call to open failed: #{e.message}"
          end
        end

        $stdout.puts "Open #{url} in your browser, and then enter the code below."
        $stdout.print 'authorization_code> '
        authorization_code = $stdin.gets

        token = oauth_client.get_token(
          code: authorization_code,
          grant_type: 'authorization_code',
          need_refresh_token: 'true',
          parse: :json,
          redirect_uri: 'urn:ietf:wg:oauth:2.0:oob'
        ).to_hash

        token
      end

      def refresh
        if refresh_token
          response = post(
            api_call: 'getToken',
            api_namespace: 'system.oauth2',
            api_version: '1',
            # protocol: 'http',
            auth: false,
            sign: false,
            params: {
              grant_type: 'refresh_token',
              client_id: client_id,
              client_secret: client_secret,
              refresh_token: refresh_token
            }
          )
          AliExpress.access_token = response['access_token']
        else
          raise Exception, 'You must have a refresh_token to refresh authorization. You need to call `AliExpress::Auth.authorize` and follow the instructions to generate one.'
        end
      end

      private

      def client
        OAuth2::Client.new(
          client_id,
          client_secret,
          site: 'https://gw.api.alibaba.com',
          authorize_url: '/auth/authorize.htm',
          token_url: "/openapi/http/1/system.oauth2/getToken/#{client_id}"
        )
      end

      def sign(hash)
        OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest.new('sha1'),
          client_secret,
          hash.sort.flatten.join.to_s
        ).upcase
      end

      def params(state)
        {
          client_id: client_id,
          redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
          site: 'aliexpress',
          state: state
        }
      end
    end
  end
end
