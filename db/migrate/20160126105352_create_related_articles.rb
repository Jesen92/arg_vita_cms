class CreateRelatedArticles < ActiveRecord::Migration
  def change
    create_table :related_articles do |t|
      t.integer :article_id
      t.integer :related_article_id

      t.timestamps null: false
    end
  end
end
