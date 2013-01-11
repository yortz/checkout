module Ecommerce
  class DiscountRule < PricingRule
    
    def self.respond_to?(method_name)
      return true if matches?(method_name)
      super
    end

    def self.matches?(method_name) 
      method_name.to_s.split("_")[0] == "buy" && method_name.to_s.split("_").last == "free"
    end

    def self.discount! method_name, item_code
      threshold = method_name.to_s.split("_")[1]
      quantity  = method_name.to_s.split("_")[3]
      discount(quantity.to_f, item_code) if threshold.match(/\d/) && quantity.match(/\d/)
    end
      
    def self.discount(quantity, item_code)
      if is_offer?(quantity, item_code)
        price     = Item.find_by_code(item_code).price
        @amount  = quantity * price
        Checkout.run!(@amount)
      end
    end

    def self.is_offer? quantity, item_code
      pattern = Array.new quantity + 1 , item_code
      (Checkout.get_items * ",").scan(pattern  * ",").any?
    end
  end
end
