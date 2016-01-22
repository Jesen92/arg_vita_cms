class CreateArticleComplements < ActiveRecord::Migration
  def change
    create_table :article_complements do |t|
      t.integer :article_id
      t.integer :complement_id

      t.timestamps null: false
    end
  end
end
