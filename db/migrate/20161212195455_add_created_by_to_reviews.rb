class AddCreatedByToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :created_by, :string
  end
end
