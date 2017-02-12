class Favorite < ActiveRecord::Base
  has_many :locations
  has_many :images
  has_many :reviews
  has_many :items
  has_many :users
end