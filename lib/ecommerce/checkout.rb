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
       @method = method_name
       @arg = args.first
       check_method_call @method, @arg
     rescue NoMethodError
       p "you called a pricing rule that doesn't match the offer discount or the bulk discount method call pattern!"
     end
   end 

   private
   
   def bulk_discount? method_name
     method_name.to_s.split("_")[0] =~ /\d/ && method_name.to_s.split("_").last =~ /\d+\.+\d*/
   end

   def offer_discount? method_name
     method_name.to_s.split("_")[0] == "buy" && method_name.to_s.split("_").last == "free"
   end

   def bulk_discount! method_name, item_code
     quantity     = method_name.to_s.split("_")[1].to_i
     bulk_discount = method_name.to_s.split("_").last.to_f
     items_count   = self.cart.map(&:code).count(item_code).to_i
     p "items count is #{items_count}"
     if  quantity == items_count
       p "#{method_name} running now bitch!"
       fullprice = Item.find_by_code(item_code).price
       promotion = fullprice - bulk_discount 
       @bulk_discount = promotion * items_count
     end
   end

   def offer_discount! method_name, item_code
     treshold = method_name.to_s.split("_")[1]
     quantity = method_name.to_s.split("_")[3]
     discount(quantity.to_f, item_code) if treshold.match(/\d/) && quantity.match(/\d/)
   end

   def check_method_call method_name, arg
     if offer_discount? method_name
       offer_discount! method_name, arg
       puts "offer"
     elsif bulk_discount? method_name
       puts "bulk"
       bulk_discount! method_name, arg
     end
   end

   def get_total
     p @bulk_discount
     @total - (@discount ||= 0) - (@bulk_discount ||= 0)
     #@rule1 = @discount.present? ? @total - @discount : @total
     #@rule2 = @bulk_discount.present? ? @total - @bulk_discount : @total
     #@total = @rule1 + @rule2
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
    p pattern
    p self.cart.map(&:code)
    (self.cart.map(&:code) * ",").scan(pattern  * ",").any?
  end

  end
end
