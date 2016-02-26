class AddHasTypesAndHasColorsToSubcategories < ActiveRecord::Migration
  def change
    add_column :subcategories, :has_types, :boolean
    add_column :subcategories, :has_colors, :boolean
  end
end
