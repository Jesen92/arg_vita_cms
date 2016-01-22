class AddPictureIdToComplements < ActiveRecord::Migration
  def change
    add_column :complements, :picture_id, :integer
  end
end
