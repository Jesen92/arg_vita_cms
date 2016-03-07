class CreateRelatedArticles
  def initialize(params, article)
    @params = params
    @article = article
  end

  def create_related_articles

    RelatedArticle.where(article_id: @article.id).destroy_all
    RelatedArticle.where(related_article_id: @article.id).destroy_all

    if @params[:related_articles]
      if @params[:related_articles][:related_article_ids]

        puts "IMA RELATED ARTICLES!!! "

        @params[:related_articles][:related_article_ids].each do |art_id|

          if !art_id.empty?
            RelatedArticle.create(article_id: @article.id, related_article_id: art_id)
            RelatedArticle.create(article_id: art_id, related_article_id: @article.id)
          end
        end
      end


      if @params[:related_articles][:related_article_codes]

        arts = Article.where(code: @params[:related_articles][:related_article_codes])

        arts.each do |art|

          if !art.code.blank?
            RelatedArticle.create(article_id: @article.id, related_article_id: art.id)
            RelatedArticle.create(article_id: art.id, related_article_id: @article.id)
          end
        end

      end
    end
  end

end