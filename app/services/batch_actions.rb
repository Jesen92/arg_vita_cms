class BatchActions
  def initialize(params)
    @params = params
  end

  def articles_batch_action
    @indicator = false
    flash = nil

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

        flash = "Artikli su izbrisani!"


      elsif @params[:commit] == 'Stavi na prodaju'

        @art.update_all(for_sale: true)

        flash = "Artikli su stavljeni na prodaju!"


      elsif @params[:commit] == 'Makni sa prodaje'

        @art.update_all(for_sale: false)

        flash = "Artikli su maknuti iz prodaje!"


      elsif @params[:commit] == 'Stavi u Izdvojene artikle'

        @art.update_all(feature_product: true)

        flash = "Artikli stavljeni u izdvojene Artikle!"

      elsif @params[:commit] == 'Makni iz Izdvojenih artikla'

        @art.update_all(feature_product: false)

        flash = "Artikli maknuti iz  Izdvojenih artikla!"

      elsif @params[:commit] == 'Makni sa popusta'

        @art.update_all(discount: 0)

        flash = "Maknuti popusti sa Artikla!"

      end

      return @indicator, @art_ids, flash
      #############################      #############################

  end


  def complements_batch_actions
    @indicator = false
    flash = nil

      @comp = Complement.where(id: @params[:complements][:selected])

      if @params[:commit] == 'Izbriši komplete'
        @comp.destroy_all
        flash = "Kompleti su izbrisani!"

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

      return @indicator, @comp_ids, flash


  end

end