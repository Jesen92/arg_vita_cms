class AddDimensionToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :dimension, :string
  end
end
