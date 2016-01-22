class AddSingleArticleIdToArticleComplements < ActiveRecord::Migration
  def change
    add_column :article_complements, :single_article_id, :integer
  end
end
