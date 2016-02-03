class AddArticleSentToPastPurchases < ActiveRecord::Migration
  def change
    add_column :past_purchases, :article_sent, :boolean
  end
end
