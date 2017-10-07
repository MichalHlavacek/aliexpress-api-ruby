require 'json'
require 'rest-client'
require 'addressable'
require 'oauth2'

module AliExpress
  class << self
    attr_accessor :client_id, :client_secret, :access_token, :refresh_token

    attr_writer :protocol, :host, :base_uri
    attr_writer :currency, :language
    attr_writer :logger

    def protocol
      @protocol || 'https'
    end

    def host
      @host || 'gw.api.alibaba.com'
    end

    def base_uri
      @base_uri || "#{protocol}://#{host}/openapi"
    end

    def currency
      @currency || 'USD'
    end

    def language
      @language || 'en'
    end

    def logger
      @logger ||= Logger.new('/dev/null')
      @logger
    end
  end
end

require File.dirname(__FILE__) + '/aliexpress/base'
require File.dirname(__FILE__) + '/aliexpress/response_error'
require File.dirname(__FILE__) + '/aliexpress/auth'
require File.dirname(__FILE__) + '/aliexpress/product'
require File.dirname(__FILE__) + '/aliexpress/affiliate'
