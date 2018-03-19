class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes do |t|
      t.string :title
      t.string :title_eng

      t.timestamps null: false
    end
  end
end
