class Category < ActiveRecord::Base
  has_many :postings, :dependent => :nullify
end
