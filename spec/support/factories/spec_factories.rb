FactoryGirl.define do
  factory :location do
    name { Faker::Company.name }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    country { Faker::Address.country }
    description { Faker::Lorem.paragraph }
    created_by { Faker::Name.name }
  end

  factory :item do
    location_id 0
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    created_by { Faker::Name.name }
    thumbnail { "https://placekitten.com/g/200/300" }
  end

  factory :review do
    item_id 0
    description { Faker::Lorem.paragraph }
    rating { rand(0..5) }
  end

  factory :image do
    item_id 0
    location_id 0
    review_id 0
    cloudinary_id { Faker::Lorem.characters(20) }
  end
end