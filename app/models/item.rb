class Item < ActiveRecord::Base
  attr_accessor :code, :name, :price

  def initialize(code, name, price)
    @code  = code
    @name  = name
    @price = price.scan(/[-+]?[0-9]*\.?[0-9]+/).first.to_f
  end

end

