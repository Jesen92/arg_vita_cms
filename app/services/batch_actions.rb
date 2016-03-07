class BatchActions
  def initialize(params)
    @params = params
  end

  def articles_batch_action
    @indicator = false

      if @params[:articles]
        @art = Article.where(id: @params[:articles][:selected])
      elsif @params[:raw]
        @art = Article.where(id: @params[:raw][:selected])
      elsif @params[:auction]
        @art = Auction.where(id: @params[:auction][:selected])
      end

      @art_ids = []

      if @art != nil
        @art.each do |a|
          @art_ids.push(a.id)
        end
      end

      #############################      ############################# odredivanje opcije koja je stisnuta
      if @params[:commit] == 'Izbriši artikle'

        SingleArticle.destroy_all(article_id: @art)

        @art.destroy_all

        flash[:notice] = "Artikli su izbrisani!"


      elsif @params[:commit] == 'Stavi na prodaju'

        @art.update_all(for_sale: true)

        flash[:notice] = "Artikli su stavljeni na prodaju!"


      elsif @params[:commit] == 'Makni sa prodaje'

        @art.update_all(for_sale: false)

        flash[:notice] = "Artikli su maknuti prodaju!"



      elsif @params[:commit] == 'Stavi u Izdvojene artikle'

        @art.update_all(feature_product: true)

      elsif @params[:commit] == 'Makni iz Izdvojenih artikla'

        @art.update_all(feature_product: false)




      elsif @params[:commit] == 'Makni sa popusta'

        @art.update_all(discount: 0)

      end

      return @indicator, @art_ids
      #############################      #############################

  end


  def complements_batch_actions
    @indicator = false

      @comp = Complement.where(id: @params[:complements][:selected])

      if @params[:commit] == 'Izbriši komplete'
        @comp.destroy_all
        flash[:notice] = "Kompleti su izbrisani!"

      elsif @params[:commit] == 'Stavi na prodaju'
        @comp.update_all(for_sale: true)

      elsif @params[:commit] == 'Makni sa prodaje'
        @comp.update_all(for_sale: false)

      elsif @params[:commit] == 'Makni sa popusta'
        @comp.update_all(discount: 0)
      end

      @comp_ids = []

      @comp.each do |a|
        @comp_ids.push(a.id)
      end

      return @indicator, @comp_ids


  end

end