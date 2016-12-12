class AddCreatedByToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :created_by, :string
  end
end
