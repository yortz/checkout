# encoding: UTF-8
require File.expand_path("../../../spec_helper", __FILE__)

describe "Checkout" do

  let(:pricing_rules) { ["buy_1_get_1_free FR1", "3_for_4.50 SR1"] }
  let(:co) { Ecommerce::Checkout.new pricing_rules }

  describe "#init" do
    it "returns a set of rules" do
      co.pricing_rules.should eq ["buy_1_get_1_free FR1", "3_for_4.50 SR1"]
    end
  end

  let(:fr1) { create :fr1 }
  let(:sr1) { create :sr1 }
  let(:cf1) { create :cf1 }
  
  describe "#scan" do
    it "adds an item to the cart" do
      co.scan fr1
      cart_item = co.cart.first
      cart_item.code.should  eq "FR1"
      cart_item.name.should  eq "Fruit Tea"
      cart_item.price.should eq 3.11
    end
  end

  describe "#total" do
    it "calculates total with no discount" do
      co.scan fr1
      co.scan sr1
      co.scan fr1
      co.scan cf1
      co.total.should eq 22.45
    end

    it "buy_1_get_1_free FR1" do
      co.scan fr1
      co.scan fr1
      co.total.should eq 3.11
    end

    it "3_for_4.50 SR1" do
      co.scan sr1
      co.scan sr1
      co.scan fr1
      co.scan sr1
      co.total.should eq 16.61
    end
  end
  
end
