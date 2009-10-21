class AddIndexesToDatabase < ActiveRecord::Migration
  def self.up
    add_index :categories, :name
    add_index :posting_types, :name
  end

  def self.down
    remove_index :categories, :name
    remove_index :posting_types, :name
  end
end
