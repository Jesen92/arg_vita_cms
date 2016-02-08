class AddComplementIdToPastPurchases < ActiveRecord::Migration
  def change
    add_column :past_purchases, :complement_id, :integer
  end
end
