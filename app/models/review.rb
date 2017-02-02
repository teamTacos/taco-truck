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
    if images.count > 0
      ImageCloudHelper.remove_images_by_id(images)
      images.delete_all
    end
  end
end
