class Posting < ActiveRecord::Base
  belongs_to :user
  belongs_to :posting_type
  belongs_to :category
  has_one :location, :as => :locatable, :dependent => :destroy

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  accepts_nested_attributes_for :location, :allow_destroy => true

  acts_as_mappable :through => :location

  validates_presence_of :title, :description, :category_id, :posting_type_id
  validates_associated :location

  has_friendly_id :title, :use_slug => true

  def accepts_role?(role, ruser)
    return self.user == ruser if role.to_s=='owner'
    super
  end
end
