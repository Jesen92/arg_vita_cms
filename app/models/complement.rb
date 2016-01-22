class Complement < ActiveRecord::Base
  has_many :article_complements
  has_many :single_articles, :through => :article_complements

  has_many :pictures, :dependent => :destroy

  belongs_to :picture
end
