class AddComplementIdToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :complement_id, :integer
  end
end
