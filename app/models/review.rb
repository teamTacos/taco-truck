class Review < ActiveRecord::Base

  belongs_to :item

  has_many :images

end
