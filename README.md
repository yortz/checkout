Simple checkout system answering the following requirements:
======================================================

it sells only 3 products.
-------------------------
```
| Product code | FR1       | SR1          | CF1    |
| Name         | Fruit tea | Strawberries | Coffee |
| Price        | £ 3.11    | £ 5.00       | £11.23 |
```

implements 2 rules for handling discounts:
------------------------------------------

1) buy 1 get 1 free Fruit Tea

2) If you buy 3 or more strawberries the price should drop to £4.50

REQUIREMENTS:
-------------
1) scan items in any order

2) flexible pricing rules

INTERFACE:
----------
```
co = Checkout.new(pricing_rules) 
co.scan(item)
co.scan(item)
Price = co.total
```

TEST DATA:
----------
```
| Basket: FR1, SR1, FR1, CF1 | Total price expected: £22.25 |
| Basket: FR1, FR1           | Total price expected: £3.11  |
| Basket: SR1, SR1, FR1, SR1 | Total price expected: £16.61 |
```

RUN:
----

```
$ git clone https://github.com/yortz/checkout.git
$ checkout rake spec
```
