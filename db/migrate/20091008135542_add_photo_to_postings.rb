class AddPhotoToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :photo_file_name,    :string
    add_column :postings, :photo_content_type, :string
    add_column :postings, :photo_file_size,    :integer
    add_column :postings, :photo_updated_at,   :datetime
  end

  def self.down
    remove_column :postings, :photo_file_name
    remove_column :postings, :photo_content_type
    remove_column :postings, :photo_file_size
    remove_column :postings, :photo_updated_at
  end
end
