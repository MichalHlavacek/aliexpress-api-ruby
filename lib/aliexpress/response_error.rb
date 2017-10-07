module AliExpress
  class ResponseError < StandardError
    attr_reader :code, :message, :response

    def initialize(code:, message:, response:)
      @code     = code
      @message  = message
      @response = response
    end
  end
end
