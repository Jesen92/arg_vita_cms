class Auction
  def initialize(params)
    @params = params
  end

  def create_auction
    start_date = DateTime.new(@params[:article]['start_date(1i)'].to_i, @params[:article]['start_date(2i)'].to_i, @params[:article]['start_date(3i)'].to_i, @params[:article]['start_date(4i)'].to_i ,@params[:article]['start_date(5i)'].to_i  )

    end_date = DateTime.new(@params[:article]['end_date(1i)'].to_i, @params[:article]['end_date(2i)'].to_i, @params[:article]['end_date(3i)'].to_i, @params[:article]['end_date(4i)'].to_i ,@params[:article]['end_date(5i)'].to_i  )


    if @params[:article][:articles]
      articles = Article.where(id: @params[:article][:articles])

      if @params[:article][:codes].length > 1
        articles_codes = Article.where(code: @params[:article][:codes])
      end

      if articles != nil
        articles.each do |a|
          puts "#{a.title}"
          Auction.create(article_id: a.id, starting_price: @params[:article][:starting_price], start_date: start_date, end_date: end_date )
        end
      end

      if articles_codes != nil
        articles_codes.each do |art|
          Auction.create(article_id: art.id, starting_price: @params[:article][:starting_price], start_date: start_date, end_date: end_date )
        end
      end

    else
      complements = Complement.where(id: @params[:article][:complements])

      complements.each do |art|
        Auction.create(complement_id: art.id, starting_price: @params[:article][:starting_price], start_date: start_date, end_date: end_date )
      end
    end
  end


end