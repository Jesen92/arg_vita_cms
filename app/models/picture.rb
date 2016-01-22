class Picture < ActiveRecord::Base
  has_one :article

  has_one :complement

  belongs_to :article

  belongs_to :complement

  belongs_to :single_article


  has_attached_file :image,
                    :styles => {thumb: "300x300>", original: "1000x1000>", gallery: "200x200#", table: "60x60#"}


  do_not_validate_attachment_file_type :image
end
