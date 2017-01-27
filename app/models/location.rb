class Location < ActiveRecord::Base

  has_many :items
  has_many :images

  attr_reader :items_count, :reviews_count, :reviews_average, :all_images

  def attributes
    super.merge(items_count: self.items_count, reviews_count: self.reviews_count, reviews_average: self.reviews_average,
                all_images: self.all_images)
  end

  def items_count
    self.items.count
  end

  def reviews_count
    self.items.inject(0){|sum, item| sum + item.reviews_count }
  end

  def reviews_average
    total = 0
    self.items.each do |item|
      total += item.reviews_average
    end
    self.items.count > 0 ? (total / self.items.count).to_i : 0
  end

  def all_images
    images
  end
end
