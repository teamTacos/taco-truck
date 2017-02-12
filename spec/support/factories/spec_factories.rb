FactoryGirl.define do
  factory :location do
    name { Faker::Company.name }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    country { Faker::Address.country }
    description { Faker::Lorem.paragraph }
    user_id 1
  end

  factory :item do
    location_id 0
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    user_id 1
  end

  factory :review do
    item_id 0
    description { Faker::Lorem.paragraph }
    rating { rand(0..5) }
    user_id 1
  end

  factory :image do
    item_id nil
    location_id nil
    review_id nil
    cloudinary_id { Faker::Lorem.characters(20) }
    user_id 1
  end

  factory :user do
    fb_user_id { Faker::Lorem.characters(20) }
    first_name { Faker::Name.first_name  }
    last_name { Faker::Name.last_name  }
    email { Faker::Internet.email }
  end

  factory :favorite do
    user_id nil
    location_id nil
    item_id nil
    review_id nil
    image_id nil
  end
end