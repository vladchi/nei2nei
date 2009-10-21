class AddCachedSlugToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :cached_slug, :string
  end

  def self.down
    remove_column :postings, :cached_slug
  end
end
