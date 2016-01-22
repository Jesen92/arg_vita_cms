class RemoveArticleIdFromArticleComplements < ActiveRecord::Migration
  def change
    remove_column :article_complements, :article_id, :integer
  end
end
