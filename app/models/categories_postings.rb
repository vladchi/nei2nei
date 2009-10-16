class CategoriesPostings < ActiveRecord::Base
  belongs_to :posting
  belongs_to :category
end
