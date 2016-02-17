class Material < ActiveRecord::Base
  has_many :articles

  has_many :category_materials
  has_many :categories, :through => :category_materials

  has_attached_file :avatar,
                    :styles => {thumb: "300x300#", table: "26x26#", index: "350x250#"}

  do_not_validate_attachment_file_type :avatar

  def self.options_for_select
    order('LOWER(title)').map { |e| [e.title, e.id] }
  end
end
