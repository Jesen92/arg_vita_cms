class UpdateMultipleSingleArticles
  def initialize(single_article_params, article)
    @single = single_article_params
    @article = article
  end

  def update

    if !@single["color_id"].blank?
      col =  Color.find(@single["color_id"])
    end


    if @single["id"] == nil

      sa = SingleArticle.new

############################################################### postavljanje naziva pojedinacnog artikla
      sa.title = @article.title
      sa.code = @article.code

      if @single["type_name"] != nil && @single["type_name"] != ""
        sa.title += "/"+@single["type_name"].to_s
        sa.code += "-"+@single["type_name"][0,2].upcase
      end

      if sa.color != nil && sa.color != ""
        sa.title += "/"+col.title
        sa.code += "-"+col.title[0,2].upcase
      end

      if @single["size"] != nil && @single["size"] != ""
        sa.title += "/"+@single["size"].to_s
        sa.code += "-"+@single["size"].to_s
      end

      if @single["amount"] == nil || @single["amount"] == ""
        sa.amount = @article.amount
      else
        sa.amount = @single["amont"]
      end

      if @single["warning"] == nil || @single["warning"] == ""
        sa.warning = @article.warning
      else
        sa.warning = @single["warning"]
      end
###############################################################


      sa.article_id = @article.id
      sa.color_id = col != nil ? col.id : nil
      sa.size = @single["size"]
      sa.type_name = @single["type_name"]
      sa.save

    else
      sa = SingleArticle.find( @single["id"])


      if @single["_destroy"] == "1"
        sa.destroy
      else

############################################################### postavljanje naziva artikla
        sa.title = @article.title
        sa.code = @article.code

        if @single["size"] != nil && @single["size"] != ""
          puts "Usao sam u postavljanje naziva za velicinu!!!!!!!!!! "
          sa.title += "/"+@single["size"].to_s
          sa.code += "-"+@single["size"].to_s
        end

        if @single["amount"] == nil || @single["amount"] == ""
          sa.amount = @article.amount
        else
          sa.amount = @single["amount"]
        end

        if @single["warning"] == nil || @single["warning"] == ""
          sa.warning = @article.warning
        else
          sa.warning = @single["warning"]
        end
###############################################################

        sa.color_id = col != nil ? col.id : nil
        sa.size = @single["size"]
        sa.type_name = @single["type_name"]
        sa.save
      end
    end
  end

end