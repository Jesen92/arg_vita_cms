class PastPurchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :single_article
end
