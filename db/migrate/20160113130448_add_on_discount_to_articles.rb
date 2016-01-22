class AddOnDiscountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :on_discount, :boolean
  end
end
