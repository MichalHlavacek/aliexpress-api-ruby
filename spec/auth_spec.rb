require 'spec_helper'

# rspec spec/auth_spec.rb
describe AliExpress::Auth do
  describe '.authorize' do
    let(:authorization_code) { 'b5ce38e1-833c-4f15-bd29-65e85db9bd2e' }
    let(:response) do
      {
        'refresh_token_timeout' => '20180402143144000-0700',
        'aliId' => 'fake-ali-id',
        'resource_owner' => 'fake-resource-owner',
        access_token: 'new-fake-access-token',
        refresh_token: 'new-fake-refresh-token',
        expires_at: 1507266354
      }
    end

    it 'creates a new access token' do
      stub_const('RUBY_PLATFORM', 'test')
      allow($stdin).to receive(:gets).and_return(authorization_code)
      allow($stdout).to receive(:puts).and_return(nil)
      allow($stdout).to receive(:print).and_return(nil)
      expect_any_instance_of(OAuth2::Client).to receive(:get_token).exactly(1).times.with(hash_including(code: authorization_code)).and_return(response)
      expect(AliExpress::Auth.authorize).to eq(response)
    end
  end

  describe '.refresh' do
    let(:response) do
      mock = double
      allow(mock).to receive(:code).and_return(200)
      allow(mock).to receive(:body).and_return('{"aliId":"fake-ali-id","resource_owner":"fake-resource-owner","expires_in":"36000","access_token":"jabber_wocky"}')
      mock
    end

    it 'exchanges the refresh token for a new access token' do
      expect(RestClient).to receive(:post).exactly(1).times.and_return(response)
      expect(AliExpress::Auth.refresh).to eq('jabber_wocky')
    end
  end
end
