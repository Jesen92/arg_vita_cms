class AddAttachmentImageToHomeBanners < ActiveRecord::Migration
  def self.up
    change_table :home_banners do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :home_banners, :image
  end
end
