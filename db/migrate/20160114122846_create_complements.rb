class CreateComplements < ActiveRecord::Migration
  def change
    create_table :complements do |t|
      t.string :title
      t.string :title_eng
      t.text :description
      t.text :description_eng

      t.timestamps null: false
    end
  end
end
