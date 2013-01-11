module Ecommerce
  class BulkDiscountRule < PricingRule

    def self.respond_to?(method_name)
      return true if matches?(method_name)
      super
    end

    def self.matches? method_name
      method_name.to_s.split("_")[0] =~ /\d/ && method_name.to_s.split("_").last =~ /\d+\.+\d*/
    end

    def self.discount! method_name, item_code
      quantity      = method_name.to_s.split("_")[0].to_i
      bulk_discount = method_name.to_s.split("_").last.to_f
      items_count   = Checkout.get_items.count(item_code)
      if  quantity == items_count
        fullprice = Item.find_by_code(item_code).price
        promotion = fullprice - bulk_discount
        @discount = promotion * items_count
        Checkout.run! @discount
      end
    end
  end
end
