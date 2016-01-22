class AddComplementIdToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :complement_id, :integer
  end
end
