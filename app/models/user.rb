class User < ActiveRecord::Base
  acts_as_voter
  has_one :shopping_cart

  has_many :past_purchases
  has_many :single_articles, :through => :past_purchases

  has_many :auctions
end
