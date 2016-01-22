class AddForSaleAndCostToComplements < ActiveRecord::Migration
  def change
    add_column :complements, :for_sale, :boolean
    add_column :complements, :cost, :decimal
  end
end
