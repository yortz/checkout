FactoryGirl.define do
  factory :item do
    trait :FR1 do
      code "FR1"
      name "Fruit Tea"
      price "3.11"
    end

    trait :SR1 do
      code "SR1"
      name "Strawberries"
      price "5.00"
    end

    trait :CF1 do
      code "CF1"
      name "Coffee"
      price "11.23"
    end

    factory :fr1, traits: [:FR1]
    factory :sr1, traits: [:SR1]
    factory :cf1, traits: [:CF1]
  end
end
