module Ecommerce
  class PricingRule < Struct.new :name
    attr_accessor :name
    
    class << self
      attr_reader :discount_classes
    end

    @discount_classes = [Ecommerce::DiscountRule, Ecommerce::BulkDiscountRule]

    def initialize(name)
      @name = name
    end

    def self.method_missing(method_name, *args)
      begin
       self.check_method_call method_name, args.first
      rescue NoMethodError
        p "you called a pricing rule that doesn't match the offer discount or the bulk discount method call pattern!"
      end
    end 

    def self.check_method_call method_name, item_code
      discount_class = Ecommerce::PricingRule.discount_classes.find do |klass|
        klass.discount! method_name, item_code
      end
      return discount_class.discount!(method_name, item_code) if discount_class
      nil
    end

  end
end
