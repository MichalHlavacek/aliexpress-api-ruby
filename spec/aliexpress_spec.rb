require 'spec_helper'

# rspec spec/aliexpress_spec.rb
describe AliExpress do
  describe '.client_id' do
    subject { AliExpress.client_id }
    it { is_expected.to eq('fake-client-id') }

    context('when assigned') do
      before { AliExpress.client_id = 'foo' }
      it { is_expected.to eq('foo') }
    end
  end

  describe '.client_secret' do
    subject { AliExpress.client_secret }
    it { is_expected.to eq('fake-client-secret') }

    context('when assigned') do
      before { AliExpress.client_secret = 'foo' }
      it { is_expected.to eq('foo') }
    end
  end

  describe '.access_token' do
    subject { AliExpress.access_token }
    it { is_expected.to eq('fake-access-token') }

    context('when assigned') do
      before { AliExpress.access_token = 'foo' }
      it { is_expected.to eq('foo') }
    end
  end

  describe '.refresh_token' do
    subject { AliExpress.refresh_token }
    it { is_expected.to eq('fake-refresh-token') }

    context('when assigned') do
      before { AliExpress.refresh_token = 'foo' }
      it { is_expected.to eq('foo') }
    end
  end

  describe '.protocol' do
    subject { AliExpress.protocol }
    it { is_expected.to eq('https') }

    context('when assigned') do
      before { AliExpress.protocol = 'foo' }
      it { is_expected.to eq('foo') }
    end
  end

  describe '.host' do
    subject { AliExpress.host }
    it { is_expected.to eq('gw.api.alibaba.com') }

    context('when assigned') do
      before { AliExpress.host = 'foo' }
      it { is_expected.to eq('foo') }
    end
  end

  describe '.base_uri' do
    subject { AliExpress.base_uri }
    it { is_expected.to eq('https://gw.api.alibaba.com/openapi') }

    context('when assigned') do
      before { AliExpress.base_uri = 'foo' }
      it { is_expected.to eq('foo') }
    end
  end

  describe '.currency' do
    subject { AliExpress.currency }
    it { is_expected.to eq('USD') }

    context('when assigned') do
      before { AliExpress.currency = 'foo' }
      it { is_expected.to eq('foo') }
    end
  end

  describe '.language' do
    subject { AliExpress.language }
    it { is_expected.to eq('en') }

    context('when assigned') do
      before { AliExpress.language = 'foo' }
      it { is_expected.to eq('foo') }
    end
  end
end
