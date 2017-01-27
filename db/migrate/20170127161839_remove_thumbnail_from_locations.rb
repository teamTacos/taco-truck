class RemoveThumbnailFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :thumbnail, :string
  end
end
