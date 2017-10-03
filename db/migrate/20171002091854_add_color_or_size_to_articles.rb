class AddColorOrSizeToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :color_or_size, :string
  end
end
