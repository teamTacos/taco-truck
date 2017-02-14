class RemoveBannerImageFromLocations < ActiveRecord::Migration[5.0]
  def change
    remove_column :locations, :banner_image, :integer
  end
end
