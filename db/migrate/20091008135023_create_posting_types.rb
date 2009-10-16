class CreatePostingTypes < ActiveRecord::Migration
  def self.up
    create_table :posting_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :posting_types
  end
end
