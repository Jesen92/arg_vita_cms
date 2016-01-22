class AddDiscountAndOnDiscountToComplements < ActiveRecord::Migration
  def change
    add_column :complements, :discount, :integer
    add_column :complements, :on_discount, :boolean
  end
end
