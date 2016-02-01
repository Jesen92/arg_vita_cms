class AddArticleIdToPastPurchases < ActiveRecord::Migration
  def change
    add_column :past_purchases, :article_id, :integer
  end
end
