class Item < ActiveRecord::Base

  belongs_to :location
  has_many :reviews
  has_many :images

  attr_reader :reviews_count, :reviews_average, :all_images

  def attributes
    super.merge(reviews_count: self.reviews_count, reviews_average: self.reviews_average, all_images: self.all_images)
  end

  def reviews_count
    self.reviews.length
  end

  def reviews_average
    total = 0
    self.reviews.each do |review|
      total += review.rating
    end
    self.reviews.length > 0 ? (total / self.reviews.length).to_i : 0
  end

  def all_images
    images
  end

  def remove_images
    images.delete_all
  end
end
