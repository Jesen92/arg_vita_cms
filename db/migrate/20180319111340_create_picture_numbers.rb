class CreatePictureNumbers < ActiveRecord::Migration
  def change
    create_table :picture_numbers do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
