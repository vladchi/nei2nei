class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :posting_type_id
      t.integer :category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :postings
  end
end
