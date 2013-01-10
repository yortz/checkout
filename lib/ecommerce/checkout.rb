module Ecommerce
  class Checkout
    attr_accessor :pricing_rules, :cart, :total

    def initialize(pricing_rules)
      @pricing_rules = pricing_rules
      @cart  = []
      @total = 0
    end

    def scan item
      @cart.push item
    end

    def total
      cart_total
      calculate_discount_for @pricing_rules
      get_total
    end

    def self.get_items
      @@cart_items
    end

    def self.run!(amount)
      @@discount = amount
    end

    private
    
    def get_total
      @total - (@@discount ||= 0)
    end

    def cart_total
      @total = @cart.map(&:price).reduce(:+)
      @@cart_items = @cart.map(&:code)
    end

    def calculate_discount_for pricing_rules
      pricing_rules.each do |rule|
        PricingRule.send rule.split.first.to_sym, rule.split.last
      end
    end

  end
end
