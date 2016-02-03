class AddCostToPastPurchase < ActiveRecord::Migration
  def change
    add_column :past_purchases, :cost, :decimal
  end
end
