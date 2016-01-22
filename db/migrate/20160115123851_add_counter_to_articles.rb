class AddCounterToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :counter, :integer
  end
end
