class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.integer :article_id
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :starting_price
      t.decimal :highest_bid
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
