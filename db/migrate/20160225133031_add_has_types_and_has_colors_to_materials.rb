class AddHasTypesAndHasColorsToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :has_types, :boolean
    add_column :materials, :has_colors, :boolean
  end
end
