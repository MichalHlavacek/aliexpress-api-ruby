require 'spec_helper'

# rspec spec/affiliate_spec.rb
describe AliExpress::Affiliate do
  let(:response) do
    mock = double
    allow(mock).to receive(:code).and_return(200)
    allow(mock).to receive(:body).and_return(json)
    mock
  end

  let(:products) { [] }
  let(:product) { {} }
  let(:json) { { errorCode: 20010000, results: { products: products } }.to_json }

  describe '.list_promotion_product' do
    let(:url) { 'https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listPromotionProduct/fake-client-id?fields=productId&keywords=drone' }

    it 'returns products' do
      expect(RestClient).to receive(:get).exactly(1).times.with(url).and_return(response)
      expect(AliExpress::Affiliate.list_promotion_product(keywords: 'drone', fields: %w(productId))).to eq(products)
    end
  end

  describe '.get_promotion_product_detail' do
    let(:url) { 'https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.getPromotionProductDetail/fake-client-id?fields=productId&productId=12345' }

    it 'returns a product' do
      expect(RestClient).to receive(:get).exactly(1).times.with(url).and_return(response)
      expect(AliExpress::Affiliate.get_promotion_product_detail(12345, fields: %w(productId))).to eq(product)
    end
  end

  describe '.list_hot_products' do
    let(:url) { 'https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.listHotProducts/fake-client-id?categoryId=3&language=en&localCurrency=USD' }

    it 'returns products' do
      expect(RestClient).to receive(:get).exactly(1).times.with(url).and_return(response)
      expect(AliExpress::Affiliate.list_hot_products(3)).to eq(products)
    end
  end
end
