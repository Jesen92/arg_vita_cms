class AddAmountToPastPurchase < ActiveRecord::Migration
  def change
    add_column :past_purchases, :amount, :integer
  end
end
