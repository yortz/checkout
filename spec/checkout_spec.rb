# encoding: UTF-8
require_relative '../app/models/item'
require_relative '../lib/checkout'

describe "Checkout" do

  let(:co) { Checkout.new "FR1, SR1, FR1, CF1" }

  describe "#init" do
    it "returns a set of rules" do
      co.rule.should eq "FR1, SR1, FR1, CF1" 
    end
  end

  describe "#scan" do

    let(:item) { Item.new "FR1", "Fruit Tea", "£ 43.11" }
    
    it "adds an item to the cart" do
      co.scan item
      cart_item = co.cart.first
      cart_item.code.should  eq "FR1"
      cart_item.name.should  eq "Fruit Tea"
      cart_item.price.should eq 43.11
    end

    it "calculates total from cart items" do
      co.scan item
      co.scan item
      co.total.should eq 86.22
    end
  end
  
end
