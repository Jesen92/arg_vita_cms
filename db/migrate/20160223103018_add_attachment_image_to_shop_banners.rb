class AddAttachmentImageToShopBanners < ActiveRecord::Migration
  def self.up
    change_table :shop_banners do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :shop_banners, :image
  end
end
