class Article < ActiveRecord::Base
  require 'csv'

  has_many :related_articles
  has_many :related_articles, :through => :related_articles

  has_many :article_categories
  has_many :categories, :through => :article_categories

  has_many :carts_articles
  has_many :shopping_carts, :through => :carts_articles

  has_many :auctions

  belongs_to :material
  belongs_to :subcategory
  belongs_to :ssubcategory

  belongs_to :picture

  has_many :coupons

  has_many :single_articles
  accepts_nested_attributes_for :single_articles, allow_destroy: true

  has_many :pictures, :dependent => :destroy

  attr_accessor :colors

  def discount_job
    @art = Article.where("discount > 0")

    if !@art.empty?

      @art.each do |art|
        if art.start_date != nil && art.end_date != nil
          if art.start_date > DateTime.now && art.end_date < DateTime.now
            @art.update_all(on_discount: true)
          elsif art.end_date > DateTime.now
            @art.update_all(on_discount: false)
          end

      end

      end
    end
  end

  after_save { |article|

    article.single_articles.each do |sa|

      sa.title = article.title
      sa.code = article.code

      if sa.color != nil && sa.color != ""
        sa.title += "/"+sa.color.title
        sa.code += "-"+sa.color.title[0,1].upcase
      end

      if sa.size != nil && sa.size != ""
        sa.title += "/"+sa.size.to_s
        sa.code += "-"+sa.size.to_s
      end


      if sa.amount == nil
        sa.amount = article.amount
      end

      if sa.warning == nil
        sa.warning = article.warning
      end

      sa.save
    end

  }

  filterrific(
      default_filter_params: { sorted_by: 'created_at_desc' },
      available_filters: [
          :sorted_by,
          :search_query,
          :with_material_id,
          :with_category_id,
          :with_created_at_gte
      ]
  )


  def self.import(file)
    # runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Article.create! row.to_hash
    end
  end

  # define ActiveRecord scopes for
  # :search_query, :sorted_by, :with_country_id, and :with_created_at_gte

  scope :sorted_by, lambda { |sort_option|
                    # extract the sort direction from the param value.
                    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
                    case sort_option.to_s
                      when /^created_at_/

                        order("articles.created_at #{ direction }")
                      when /^updated_at_/

                        order("articles.updated_at #{ direction }")
                      when /^title_/

                        order("LOWER(articles.title) #{ direction }")
                      else
                        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
                    end
                  }

  scope :with_category_id, lambda { |category_ids|
                          where(category_id: [*category_ids])
                        }

  scope :with_material_id, lambda { |material_ids|
                           where(material_id: [*material_ids])
                         }

  scope :with_created_at_gte, lambda { |ref_date|
                              where(created_at: [*ref_date])
                            }

  scope :search_query, lambda { |query|

                       return nil  if query.blank?


                       terms = query.downcase

                       # replace "*" with "%" for wildcard searches,
                       # append '%', remove duplicate '%'s

                       # configure number of OR conditions for provision
                       # of interpolation arguments. Adjust this if you
                       # change the number of OR conditions.
                       num_or_conds = 1
                       where(
                             "(LOWER(articles.title) LIKE ? OR LOWER(articles.title_eng) LIKE ?)", "%#{terms}%", "%#{terms}%"
                       )
                     }

  def self.options_for_sorted_by
    [
        ['Nazivu (a-z)', 'title_asc'],
        ['Datumu kreiranja (najnoviji)', 'created_at_desc'],
        ['Datumu kreiranja (stariji)', 'created_at_asc'],
        ['Datumu izmjene (najnoviji)', 'updated_at_desc'],
        ['Datumu izmjene (stariji)', 'updated_at_asc']
    ]
  end
end
