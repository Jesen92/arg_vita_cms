class SingleArticlesController < ApplicationController
  def index
  end

  def show
    @single_article = SingleArticle.find(params[:id])

    @discount_prize = nil

    if @single_article.article.discount != nil && @single_article.article.discount != 0
      @discount_prize = (@single_article.article.cost-(@single_article.article.cost*@single_article.article.discount/100))
    end
  end


end

