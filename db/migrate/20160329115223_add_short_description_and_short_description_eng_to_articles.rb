class AddShortDescriptionAndShortDescriptionEngToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :short_description, :string
    add_column :articles, :short_description_eng, :string
  end
end
