class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string  :locatable_type
      t.integer :locatable_id
      t.float  :lat
      t.float  :lng
      t.string :country
      t.string :state
      t.string :city
      t.string :address_line
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
