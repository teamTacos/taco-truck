class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :item_id
      t.string :description
      t.integer :rating
    end

  end
end
