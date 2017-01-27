class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :cloudinary_id
      t.integer :location_id
      t.integer :item_id
      t.integer :review_id
      t.integer :location_banner
      t.integer :review_banner
      t.integer :item_banner
    end
  end
end
