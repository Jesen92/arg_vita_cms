class User < ActiveRecord::Base
  has_one :shopping_cart

  has_many :past_purchases
  has_many :single_articles, :through => :past_purchases

  has_many :auctions
end
