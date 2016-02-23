class CreateShopBanners < ActiveRecord::Migration
  def change
    create_table :shop_banners do |t|
      t.string :title
      t.integer :order
      t.boolean :active

      t.timestamps null: false
    end
  end
end
