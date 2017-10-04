require 'active_model'
require 'json'
require 'addressable'
require 'oauth2'

module AliExpress
  class << self
    attr_accessor :api_path, :app_key, :app_secret, :access_token, :refresh_token, :logger

    def api_path
      @api_path || 'https://gw.api.alibaba.com/openapi/param2'
    end

    def client_id
      app_key
    end

    def client_secret
      app_secret
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

require File.dirname(__FILE__) + '/aliexpress/resource'
require File.dirname(__FILE__) + '/aliexpress/auth'
require File.dirname(__FILE__) + '/aliexpress/product'
