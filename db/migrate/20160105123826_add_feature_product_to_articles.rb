class AddFeatureProductToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :feature_product, :boolean
  end
end
