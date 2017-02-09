class RemoveCreatedByFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :created_by, :string
  end
end
