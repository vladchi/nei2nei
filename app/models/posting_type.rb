class PostingType < ActiveRecord::Base
  has_many :postings, :dependent => :nullify
end
