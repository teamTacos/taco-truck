FactoryGirl.define do
  factory :location do
    name { Faker::Company.name }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    country { Faker::Address.country }
    description { Faker::Lorem.paragraph }
  end

  factory :item do
    location_id 0
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
  end

end