# encoding: UTF-8
require File.expand_path("../../../spec_helper", __FILE__)

describe "Checkout" do

  let(:discount_rule) {Ecommerce::PricingRule.new "buy_1_get_1_free FR1"}
  let(:bulk_discount_rule) {Ecommerce::PricingRule.new "3_for_4.50 SR1"}
  let(:pricing_rules) {[ discount_rule.name, bulk_discount_rule.name ]}
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
    context "when no rules" do
      it "doesn't apply discount" do
        co.scan fr1
        co.scan sr1
        co.scan fr1
        co.scan cf1
        co.total.should eq 22.45
      end
    end

    context "when buy_1_get_1_free FR1" do
      it "applies discount rule" do
        co.scan fr1
        co.scan fr1
        co.total.should eq 3.11
      end
    end

    context "when 3_for_4.50 SR1" do
      it "applies bulk discount rule" do
        co.scan sr1
        co.scan sr1
        co.scan fr1
        co.scan sr1
        co.total.should eq 16.61
      end
    end

  end
  
end
