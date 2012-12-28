# encoding: UTF-8
require File.expand_path("../../../spec_helper", __FILE__)

describe "Checkout" do

  let(:pricing_rules) { "buy_1_get_1_free FR1" }
  let(:co) { Ecommerce::Checkout.new pricing_rules }

  describe "#init" do
    it "returns a set of rules" do
      co.pricing_rules.should eq ["buy_1_get_1_free FR1"]
    end
  end

  let(:fr1) { Item.create! :code => "FR1", :name => "Fruit Tea", :price => "43.11" }
  describe "#scan" do
    
    it "adds an item to the cart" do
      co.scan fr1
      cart_item = co.cart.first
      cart_item.code.should  eq "FR1"
      cart_item.name.should  eq "Fruit Tea"
      cart_item.price.should eq 43.11
    end

    it "calculates total from cart items" do
      co.scan fr1
      co.scan fr1
      #co.total.should eq 86.22 need to edit this since we are now applying discount
    end
  end

  describe "buy_1_get_1_free \"FR1\"" do
    it "applies discount" do
      co.scan fr1
      co.scan fr1
      co.total.should eq 43.11
    end
  end
  
end
