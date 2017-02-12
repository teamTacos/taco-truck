class User < ActiveRecord::Base
  has_many :locations
  has_many :images
  has_many :reviews
  has_many :items
end