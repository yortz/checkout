module Ecommerce
  class PricingRule < Struct.new :name
    attr_accessor :name

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
      if DiscountRule.respond_to?(method_name)
        DiscountRule.discount! method_name, item_code
        nil
      elsif BulkDiscountRule.respond_to?(method_name)
        BulkDiscountRule.discount! method_name, item_code
        nil
      end
    end

  end
end
