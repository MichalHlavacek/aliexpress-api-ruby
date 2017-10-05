RSpec.configure do |config|
  config.before(:each) do
    AliExpress.client_id     = 'fake-client-id'
    AliExpress.client_secret = 'fake-client-secret'
    AliExpress.access_token  = 'fake-access-token'
    AliExpress.refresh_token = 'fake-refresh-token'

    %i(protocol host base_uri currency language logger).each do |method|
      AliExpress.send("#{method}=", nil)
    end
  end
end
