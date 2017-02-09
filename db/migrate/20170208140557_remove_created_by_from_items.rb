class RemoveCreatedByFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :created_by, :string
  end
end
