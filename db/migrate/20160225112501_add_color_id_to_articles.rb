class AddColorIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :color_id, :integer
  end
end
