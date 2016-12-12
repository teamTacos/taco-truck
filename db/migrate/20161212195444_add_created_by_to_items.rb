class AddCreatedByToItems < ActiveRecord::Migration
  def change
    add_column :items, :created_by, :string
  end
end
