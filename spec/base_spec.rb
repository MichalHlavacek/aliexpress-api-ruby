require 'spec_helper'

# rspec spec/base_spec.rb
describe AliExpress::Base do
  let(:response) do
    mock = double
    allow(mock).to receive(:code).and_return(200)
    allow(mock).to receive(:body).and_return('{}')
    mock
  end

  describe '.get' do
    context 'when auth is true' do
      it 'uses the access token' do
        expect(RestClient).to receive(:get).exactly(1).times.with('https://gw.api.alibaba.com/openapi/param2/1/aliexpress.open/foo/fake-client-id?access_token=fake-access-token').and_return(response)
        AliExpress::Base.get(api_call: 'foo', sign: false, auth: true)
      end
    end

    context 'when sign is true' do
      it 'signs the request' do
        expect(RestClient).to receive(:get).exactly(1).times.with('https://gw.api.alibaba.com/openapi/param2/1/aliexpress.open/foo/fake-client-id?_aop_signature=8F19FBA00C4BF35E43FA9ED143639337047624C0').and_return(response)
        AliExpress::Base.get(api_call: 'foo', sign: true, auth: false)
      end
    end

    context 'when bogus params are used' do
      it 'raises an error' do
        expect { AliExpress::Base.get(api_call: 'foo', foo: 'bar') }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.post' do
    context 'when auth is true' do
      it 'uses the access token' do
        expect(RestClient).to receive(:post).exactly(1).times.with('https://gw.api.alibaba.com/openapi/param2/1/aliexpress.open/foo/fake-client-id', access_token: 'fake-access-token').and_return(response)
        AliExpress::Base.post(api_call: 'foo', sign: false, auth: true)
      end
    end

    context 'when sign is true' do
      it 'signs the request' do
        expect(RestClient).to receive(:post).exactly(1).times.with('https://gw.api.alibaba.com/openapi/param2/1/aliexpress.open/foo/fake-client-id', _aop_signature: '8F19FBA00C4BF35E43FA9ED143639337047624C0').and_return(response)
        AliExpress::Base.post(api_call: 'foo', sign: true, auth: false)
      end
    end
  end
end
