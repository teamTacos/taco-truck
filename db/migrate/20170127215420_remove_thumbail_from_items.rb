class RemoveThumbailFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :thumbnail, :string
  end
end
