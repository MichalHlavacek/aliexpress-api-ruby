module AliExpress
  class Resource < Base
    include ActiveModel::Model

    def initialize(hash)
      self.attributes = hash
    end

    def attributes
      self.class.attributes
    end

    def attributes=(hash)
      # Only honor valid attributes.
      hash.each do |key, value|
        if respond_to?("#{key}=")
          send("#{key}=", value)
        else
          logger.warn "Invalid attribute #{key} specified for #{self.class.name}"
        end
      end
    end

    def persisted?
      id.present? # @TODO: Should this be internal_id?
    end

    def to_h
      self.class.attributes.map { |key| [key, send(key)] }.to_h
    end

    class << self
      def attr_accessor(*vars)
        @attributes ||= {}
        vars.each { |var| @attributes[var.to_s] = true }
        super(*vars)
      end

      def attributes
        @attributes ||= {}
        @attributes.keys
      end
    end
  end
end
