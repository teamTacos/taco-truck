class AddThumbnailToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :thumbnail, :string
  end
end
