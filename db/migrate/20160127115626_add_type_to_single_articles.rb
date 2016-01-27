class AddTypeToSingleArticles < ActiveRecord::Migration
  def change
    add_column :single_articles, :type, :string
  end
end
