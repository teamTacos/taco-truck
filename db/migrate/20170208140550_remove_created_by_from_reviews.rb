class RemoveCreatedByFromReviews < ActiveRecord::Migration
  def change
    remove_column :reviews, :created_by, :string
  end
end
