class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :location_id
      t.string :name
      t.text :description
    end
  end
end
