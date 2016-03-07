class SetDiscount
  def initialize(params)
    @params = params
  end

  def article_set_discount
    articles = Article.where(id: @params[:article][:articles])

    if @params[:article][:codes].length > 1
      articles_codes = Article.where(code: @params[:article][:codes])
    end

    start_date = DateTime.new(@params[:article]['start_date(1i)'].to_i, @params[:article]['start_date(2i)'].to_i, @params[:article]['start_date(3i)'].to_i, @params[:article]['start_date(4i)'].to_i ,@params[:article]['start_date(5i)'].to_i  )

    end_date = DateTime.new(@params[:article]['end_date(1i)'].to_i, @params[:article]['end_date(2i)'].to_i, @params[:article]['end_date(3i)'].to_i, @params[:article]['end_date(4i)'].to_i ,@params[:article]['end_date(5i)'].to_i  )


    if articles != nil
      articles.update_all(discount: @params[:article][:discount], start_date: start_date, end_date: end_date )

      if !articles_codes.nil?
        articles_codes.update_all(discount: @params[:article][:discount], start_date: start_date, end_date: end_date )
      end
    end
  end


  def complement_set_discount
    complements = Complement.where(id: @params[:complement][:complements])

    start_date = DateTime.new(@params[:complement]['start_date(1i)'].to_i, @params[:complement]['start_date(2i)'].to_i, @params[:complement]['start_date(3i)'].to_i, @params[:complement]['start_date(4i)'].to_i ,@params[:complement]['start_date(5i)'].to_i  )

    end_date = DateTime.new(@params[:complement]['end_date(1i)'].to_i, @params[:complement]['end_date(2i)'].to_i, @params[:complement]['end_date(3i)'].to_i, @params[:complement]['end_date(4i)'].to_i ,@params[:complement]['end_date(5i)'].to_i  )


    if complements != nil
      complements.update_all(discount: @params[:complement][:discount], start_date: start_date, end_date: end_date )
    end
  end

end