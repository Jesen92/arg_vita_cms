class Subcategory < ActiveRecord::Base
  has_many :articles

  has_many :category_subcategories
  has_many :categories, :through => :category_subcategories

  has_many :ssubcategory_subcategories
  has_many :ssubcategories, :through => :ssubcategory_subcategories

  has_attached_file :avatar,
                    :styles => {thumb: "300x300#", table: "26x26#", index: "350x250#"}

  do_not_validate_attachment_file_type :avatar
end
