require 'active_model'
require 'json'
require 'addressable'
require 'oauth2'

module AliExpress
  class << self
    attr_accessor :protocol, :host, :base_uri
    attr_accessor :client_id, :client_secret, :access_token, :refresh_token
    attr_accessor :currency, :language
    attr_accessor :logger

    def protocol
      @protocol || 'https'
    end

    def host
      @host || 'gw.api.alibaba.com'
    end

    def base_uri
      "#{protocol}://#{host}/openapi"
    end

    def currency
      @currency || 'USD'
    end

    def language
      @language || 'en'
    end

    def logger
      unless defined?(@logger)
        @logger = Logger.new(STDOUT)
        @logger.level = Logger::WARN
      end

      @logger
    end
  end
end

require File.dirname(__FILE__) + '/aliexpress/base'
require File.dirname(__FILE__) + '/aliexpress/resource'
require File.dirname(__FILE__) + '/aliexpress/auth'
require File.dirname(__FILE__) + '/aliexpress/product'
require File.dirname(__FILE__) + '/aliexpress/affiliate'
