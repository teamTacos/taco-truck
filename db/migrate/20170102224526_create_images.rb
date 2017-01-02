class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :public_id, :string
      t.integer :location_id
      t.integer :item_id
      t.integer :review_id
    end
  end
end
