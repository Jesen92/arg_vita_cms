class Color < ActiveRecord::Base
  has_many :single_articles
  has_many :articles

  has_attached_file :avatar,
                    :styles => {thumb: "300x300#", table: "26x26#"}

  do_not_validate_attachment_file_type :avatar
end
