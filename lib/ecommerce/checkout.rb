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

   def method_missing(method_name, *args)
     begin
       check_method_call method_name, args.first
     rescue NoMethodError
       p "you called a pricing rule that doesn't match the offer discount or the bulk discount method call pattern!"
     end
   end 

   private

   def offer_discount? method_name
     method_name.to_s.split("_")[0] == "buy" && method_name.to_s.split("_").last == "free"
   end

   def check_method_call method_name, arg
     if offer_discount?(method_name)
       treshold = method_name.to_s.split("_")[1]
       quantity = method_name.to_s.split("_")[3]
       discount(quantity.to_f, arg) if treshold.match(/\d/) && quantity.match(/\d/)
     end
   end

   def get_total
     @discount.present? ? @total - @discount : @total
   end

   def cart_total
      @total = @cart.map(&:price).reduce(:+)
   end

   def calculate_discount_for pricing_rules
      pricing_rules.each do |rule|
        send rule.split.first.to_sym, rule.split.last
      end
   end

   def discount(quantity, item_code)
     if is_offer?(quantity, item_code)
       price     = Item.find_by_code(item_code).price
       @discount = quantity * price
     end
   end

  def is_offer? quantity, item_code
    pattern = Array.new quantity + 1 , item_code
    (@cart.map(&:code) * ",").scan(pattern  * ",").any?
  end

  end
end
