require 'spec_helper'

# rspec spec/affiliate_spec.rb
describe AliExpress::Affiliate do
  let(:response) do
    mock = double
    allow(mock).to receive(:code).and_return(200)
    allow(mock).to receive(:body).and_return(json)
    mock
  end

  let(:success) { 20010000 }
  let(:hash) { { 'errorCode' => success } }
  let(:json) { hash.to_json }

  # before do
  #   AliExpress.logger = Logger.new(STDOUT)
  #   AliExpress.logger.level = Logger::DEBUG
  # end

  describe '.search' do
    let(:url) { 'https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listPromotionProduct/fake-client-id?categoryId=3&fields=productId&keywords=drone&language=en&localCurrency=USD&pageNo=2&pageSize=5&sort=orignalPriceDown' }

    it 'returns a successful response' do
      expect(RestClient).to receive(:get).exactly(1).times.with(url).and_return(response)
      response = AliExpress::Affiliate.search(query: 'drone', filters: { category: 'Apparel & Accessories' }, sort: 'orignalPriceDown', page: 2, per_page: 5, fields: %w(productId))
      expect(response['errorCode']).to eq(success)
    end
  end

  describe '.find' do
    let(:url) { 'https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionProductDetail/fake-client-id?fields=productId&language=en&localCurrency=USD&productId=12345' }

    it 'returns a product' do
      expect(RestClient).to receive(:get).exactly(1).times.with(url).and_return(response)
      response = AliExpress::Affiliate.find(12345, fields: %w(productId))
      expect(response['errorCode']).to eq(success)
    end
  end

  describe '.similar' do
    let(:url) { 'https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listSimilarProducts/fake-client-id?language=en&localCurrency=USD&productId=12345' }

    it 'returns a product' do
      expect(RestClient).to receive(:get).exactly(1).times.with(url).and_return(response)
      response = AliExpress::Affiliate.similar(12345)
      expect(response['errorCode']).to eq(success)
    end
  end

  describe '.popular' do
    let(:url) { 'https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listHotProducts/fake-client-id?categoryId=3&language=en&localCurrency=USD' }

    context 'when a category id is used' do
      it 'returns a successful response' do
        expect(RestClient).to receive(:get).exactly(1).times.with(url).and_return(response)
        response = AliExpress::Affiliate.popular(3)
        expect(response['errorCode']).to eq(success)
      end
    end

    context 'when a category name is used' do
      it 'returns a successful response' do
        expect(RestClient).to receive(:get).exactly(1).times.with(url).and_return(response)
        response = AliExpress::Affiliate.popular('Apparel & Accessories')
        expect(response['errorCode']).to eq(success)
      end
    end
  end
end
