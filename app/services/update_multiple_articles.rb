class UpdateMultipleArticles
  def initialize(params, article)
    @param = params
    @article = article
  end

  def update
    @article.title = @param[:title]

    @article.title_eng = @param[:title_eng]

    @article.color_id = @param[:color_id]

    @article.type_id = @param[:type_id]

    if @param[:raw] == false
      @article.material_id = @param[:material_id]
    else
      @article.subcategory_id = @param[:subcategory_id]

      @article.ssubcategory_id =  @param[:ssubcategory_id]
    end

    @article.short_description = @param[:short_description]

    @article.short_description_eng = @param[:short_description_eng]

    @article.description = @param[:description]

    @article.description_eng = @param[:description_eng]

    @article.weight = @param[:weight]

    @article.dimension = @param[:dimension]

    @article.code = @param[:code]

    @article.suppliers_code = @param[:suppliers_code]

    @article.amount = @param[:amount]

    @article.warning = @param[:warning]

    @article.cost = @param[:cost]

    @article.discount = @param[:discount]

    @article.for_sale = @param[:for_sale]

    @article.save
  end

end