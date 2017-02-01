class Review < ActiveRecord::Base

  belongs_to :item

  has_many :images

  attr_reader :all_images

  def attributes
    super.merge(all_images: self.all_images)
  end

  def all_images
    images
  end

  def remove_images
    images.delete_all
  end
end
