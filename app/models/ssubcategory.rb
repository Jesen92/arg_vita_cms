class Ssubcategory < ActiveRecord::Base
  has_many :articles

  has_many :ssubcategory_subcategories
  has_many :subcategories, :through => :ssubcategory_subcategories

  has_attached_file :avatar,
                    :styles => {thumb: "300x300#", table: "26x26#"}

  do_not_validate_attachment_file_type :avatar
end
