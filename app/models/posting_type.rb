class PostingType < ActiveRecord::Base
  has_many :postings, :dependent => :nullify

  def to_s
    name
  end
end
