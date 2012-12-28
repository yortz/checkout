module Ecommerce
  class Checkout
    attr_accessor :pricing_rules, :cart, :total

    def initialize(pricing_rules)
      @pricing_rules = Array.new.push pricing_rules
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
     if method_name.to_s.split("_")[0] == "buy" && method_name.to_s.split("_").last == "free"
       treshold = method_name.to_s.split("_")[1]
       quantity = method_name.to_s.split("_")[3]
       if treshold.match(/\d/) && quantity.match(/\d/)
         discount(treshold, quantity, args.first)
       end
     else
       super
     end
   end 

   private

   def get_total
     @total - @discount
   end

   def cart_total
      @total = @cart.map(&:price).reduce(:+)
   end

   def calculate_discount_for pricing_rules
      pricing_rules.each do |rule|
        send rule.split.first.to_sym, rule.split.last
      end
   end

   def discount(treshold, quantity, item_code)
     if code_for?(item_code) && quantity_for(item_code) == treshold.to_i
       price    = Item.find_by_code(item_code).price
       @discount = quantity.to_f * price
     end
   end

  def code_for? item_code
    @cart.map(&:code).include? "#{item_code}"
  end

  def quantity_for item_code
    @cart.count {|item| item.code == "#{item_code}"} - 1 
  end

  end
end
