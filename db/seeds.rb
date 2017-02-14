users = []
5.times do
  user = User.create(fb_user_id: Faker::Lorem.characters(20), first_name: Faker::Name.first_name,
                     last_name: Faker::Name.last_name, email: Faker::Internet.email)
  users << user.id
end

locations = []
5.times do
  location = Location.create(name: Faker::Company.name, city: Faker::Address.city, state: Faker::Address.state_abbr,
                           country: Faker::Address.country, description: Faker::Lorem.paragraph, user_id: users.sample)
  locations << location
end

items = []
10.times do
  location = locations.sample
  item = Item.create(name: Faker::Commerce.product_name, description: Faker::Lorem.paragraph, user_id: location.user_id,
              location_id: location.id)
  items << item
end

reviews = []
30.times do
  item = items.sample
  review = Review.create(item_id: item.id, description: Faker::Lorem.paragraph, rating: rand(0..5), user_id: item.user_id )
  reviews << review
end

10.times do
  item = items.sample
  Image.create(cloudinary_id: Faker::Lorem.characters(20), item_id: item.id, user_id: item.user_id)
end

10.times do
  location = locations.sample
  Image.create(cloudinary_id: Faker::Lorem.characters(20), location_id: location.id, user_id: location.user_id)
end

10.times do
  review = reviews.sample
  Image.create(cloudinary_id: Faker::Lorem.characters(20), review_id: review.id, user_id: review.user_id)
end

10.times do
  item = items.sample
  Favorite.create(item_id: item.id, user_id: item.user_id)
end

10.times do
  location = locations.sample
  Favorite.create(location_id: location.id, user_id: location.user_id)
end

10.times do
  review = reviews.sample
  Favorite.create(review_id: review.id, user_id: review.user_id)
end
