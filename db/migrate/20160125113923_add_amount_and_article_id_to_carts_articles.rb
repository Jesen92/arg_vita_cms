class AddAmountAndArticleIdToCartsArticles < ActiveRecord::Migration
  def change
    add_column :carts_articles, :article_id, :integer
    add_column :carts_articles, :amount, :integer
  end
end
