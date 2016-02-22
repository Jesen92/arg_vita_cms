class ArticlesController < ApplicationController
  require 'csv'

  #TODO napravi da svugdje gdje se biraju artikli, da se mogu birati po kodu


  before_filter :authenticate_admin_user!

  $art

  #####################  #####################  #####################  ##################### za import CSV file-a(sa artiklima) koji se upisuju u bazu
  def import

    @csv = CsvUpload.create(csv_params)

    puts "Unutar import-a putanja csv-a je: #{@csv.document.url}"

    Article.import(@csv.document.url)

    flash[:notice] = "Dodani su artikli iz CSV datoteke"

    redirect_to(:back)
  end

  def import_view
    @csv = CsvUpload.new
  end
  #####################  #####################  #####################  #####################

  def index

    @page_title = "Artikli"
    @articles = Article.where(raw: false)
    @articles_grid = initialize_grid(@articles, name: 'articles', include: [ :categories ,:material, :pictures] ,order: 'articles.created_at', order_direction: 'desc', enable_export_to_csv: true, csv_file_name: 'artikli', csv_field_separator: ';' )

    export_grid_if_requested
  end

  def show
    @article = Article.find(params[:id])

    rel_art_ids = []
    @rel_arts = []

    rel_art_ids = RelatedArticle.where(article_id: @article.id).pluck(:related_article_id)

    @rel_arts = Article.where(id: rel_art_ids)

    if @article.end_date != nil
      gon.date = @article.end_date.strftime("%Y/%m/%d %H:%M")
    end

    @page_title = "Artikli | " + @article.title

    @discount_prize = nil

    if @article.discount != nil && @article.discount != 0
      @discount_prize = (@article.cost-(@article.cost*@article.discount/100))
    end
  end


  #####################  #####################  #####################  ##################### graficki pogled artikla(sa filterrific filterom)
  def show_pics
    @page_title = "Artikli"
    @filterrific = initialize_filterrific(Article.where(raw: false), params[:filterrific], select_options: { sorted_by: Article.options_for_sorted_by,
                                                                                           with_category_id: Category.options_for_select,
                                                                                           with_material_id: Material.options_for_select}) or return
    @articles = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end

  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return

  end
  #####################  #####################  #####################  #####################


  def new
    @article = Article.new
    @page_title = "Artikl | New"
  end

  def create
    @article = Article.new(article_params)

      if @article.save

        if params[:images]

          params[:images].each { |image|
            @article.pictures.create(image: image)
          }
        end

        @index = 0

        if params[:article][:related_articles][:related_article_ids]

          params[:article][:related_articles][:related_article_ids].each do |art_id|

            if !art_id.empty?
              RelatedArticle.create(article_id: @article.id, related_article_id: art_id)
              RelatedArticle.create(article_id: art_id, related_article_id: @article.id)
            end
          end
        end

        if params[:article][:related_articles][:related_article_codes]

          arts = Article.where(code: params[:article][:related_articles][:related_article_codes])

          arts.each do |art|

            if !art.code.blank?
              RelatedArticle.create(article_id: @article.id, related_article_id: art.id)
              RelatedArticle.create(article_id: art.id, related_article_id: @article.id)
            end
          end

        end

        @article.single_articles.each do |sa|

            image = params[:article][:single_articles_attributes].values[@index]
            if image[:pictures]!= nil
              image[:pictures].each do |pic|
                sa.pictures.create(image: pic)
              end
            end
          @index += 1
          end


        if @article.pictures != nil && @article.pictures.first != nil
          @article.picture = @article.pictures.first
        elsif @article.single_articles.first != nil && @article.single_articles.first.pictures.first != nil
          @article.picture = @article.single_articles.first.pictures.first
        end

        @article.save

        #single_articles_create

      end


    flash[:notice] = "Dodan je novi artikl!"

    if params[:subaction] == "Izradi artikl i pokreni novu formu"
      redirect_to new_article_path
    elsif params[:subaction] == "Izradi repromaterijal i pokreni novu formu"
      redirect_to raw_new_articles_path
    else
      redirect_to article_path(@article.id)
    end

  end

  def edit
    @article = Article.find(params[:format])

    @page_title = "Edit | "+@article.title

    @colors = []

    @article.single_articles.each do |s|
      if s.color != nil
        @colors.push(s.color.id)
      end
    end

  end

  def update
    @article = Article.find(params[:id])


    @article.update(article_params)

        if params[:images]
          #===== The magic is here
          params[:images].each { |image|
            @article.pictures.create(image: image)
          }
        end

    @index = 0

    RelatedArticle.where(article_id: @article.id).destroy_all
    RelatedArticle.where(related_article_id: @article.id).destroy_all

    if params[:raw] == '0'
    if params[:article][:related_articles][:related_article_ids]

      params[:article][:related_articles][:related_article_ids].each do |art_id|

        if !art_id.empty?
            RelatedArticle.create(article_id: @article.id, related_article_id: art_id)
            RelatedArticle.create(article_id: art_id, related_article_id: @article.id)
        end
      end
    end


    if params[:article][:related_articles][:related_article_codes]

      arts = Article.where(code: params[:article][:related_articles][:related_article_codes])

        arts.each do |art|

          if !art.code.blank?
            RelatedArticle.create(article_id: @article.id, related_article_id: art.id)
            RelatedArticle.create(article_id: art.id, related_article_id: @article.id)
          end
        end

    end
    end

    @article.single_articles.each do |sa|

      image = params[:article][:single_articles_attributes].values[@index]
      if image[:pictures]!= nil
        image[:pictures].each do |pic|
          sa.pictures.create(image: pic)
        end
      end


      @index += 1
    end

    flash[:notice] = "Artikl je izmijenjen!"

    redirect_to article_path(@article.id)
  end


  def destroy
    @article = Article.find(params[:id])

    SingleArticle.destroy_all(article_id: @article.id)

    @article.destroy

    flash[:notice] = "Artikl je izbrisan!"

    redirect_to articles_path
  end

  #####################  #####################  #####################  ##################### funkcije za opcije nad vise izabranih artikla
  def batch_actions

    #FIXME uljepsaj kod /service objects

    @indicator = false

    if params[:complements]

      @comp = Complement.where(id: params[:complements][:selected])

      if params[:commit] == 'Izbriši komplete'
        @comp.destroy_all
        flash[:notice] = "Kompleti su izbrisani!"

      elsif params[:commit] == 'Stavi na Aukciju'
        redirect_to set_auction_path(params)

      elsif params[:commit] == 'Stavi na prodaju'
        @comp.update_all(for_sale: true)

      elsif params[:commit] == 'Makni sa prodaje'
        @comp.update_all(for_sale: false)

      elsif params[:commit] == 'Makni sa popusta'
        @comp.update_all(discount: 0)
      end

      @comp_ids = []

      @comp.each do |a|
        @comp_ids.push(a.id)
      end

      if params[:commit] != 'Postavi popust' && params[:commit] != 'Stavi na Aukciju'
        redirect_to complements_path
      end
    else


          if params[:articles]
            @art = Article.where(id: params[:articles][:selected])
          elsif params[:raw]
            @art = Article.where(id: params[:raw][:selected])
          elsif params[:auction]
            @art = Auction.where(id: params[:auction][:selected])
          end

        @codes = Article.select(:code).map(&:code)

        @art_ids = []

          if @art != nil
            @art.each do |a|
              @art_ids.push(a.id)
            end
          end

        #############################      ############################# odredivanje opcije koja je stisnuta
       if params[:commit] == 'Izbriši artikle'

         SingleArticle.destroy_all(article_id: @art)

         @art.destroy_all

        flash[:notice] = "Artikli su izbrisani!"


       elsif params[:commit] == 'Stavi na prodaju'

         @art.update_all(for_sale: true)

         flash[:notice] = "Artikli su stavljeni na prodaju!"


       elsif params[:commit] == 'Makni sa prodaje'

         @art.update_all(for_sale: false)

         flash[:notice] = "Artikli su maknuti prodaju!"

       elsif params[:commit] == 'Uredi odabrane artikle'

         redirect_to edit_multiple_path(params)
         @indicator = true

       elsif params[:commit] == 'Stavi u Izdvojene artikle'

         @art.update_all(feature_product: true)

       elsif params[:commit] == 'Makni iz Izdvojenih artikla'

         @art.update_all(feature_product: false)

       elsif params[:commit] == 'Stavi na Aukciju'

          redirect_to set_auction_path(params)
          @indicator = true

         flash[:notice] = "Artikli su stavljeni na Aukciju!"

       elsif params[:commit] == 'Izbriši aukcije'
         @art.destroy_all

         flash[:notice] = "Aukcije su izbrisane!"

         redirect_to index_auction_path

       elsif params[:commit] == 'Makni sa popusta'

         @art.update_all(discount: 0)

       end

      if params[:commit] != 'Postavi popust'
        if params[:articles] && @indicator == false
          redirect_to articles_path
        elsif params[:raw]
          redirect_to raw_index_path
        elsif params[:article]
          redirect_to index_auction_path
        end
      end
    #############################      #############################
    end
  end


  def set_discount #sluzi za postavljanje popusta nad vise artikla/kompleta

    if params[:article]
      articles = Article.where(id: params[:article][:articles])

      if params[:article][:codes].length > 1
        articles_codes = Article.where(code: params[:article][:codes])
      end


      @page_title = "Popust"

      start_date = DateTime.new(params[:article]['start_date(1i)'].to_i, params[:article]['start_date(2i)'].to_i, params[:article]['start_date(3i)'].to_i, params[:article]['start_date(4i)'].to_i ,params[:article]['start_date(5i)'].to_i  )

      end_date = DateTime.new(params[:article]['end_date(1i)'].to_i, params[:article]['end_date(2i)'].to_i, params[:article]['end_date(3i)'].to_i, params[:article]['end_date(4i)'].to_i ,params[:article]['end_date(5i)'].to_i  )


      if articles != nil
        articles.update_all(discount: params[:article][:discount], start_date: start_date, end_date: end_date )

        if !articles_codes.nil?
          articles_codes.update_all(discount: params[:article][:discount], start_date: start_date, end_date: end_date )
        end
      end

      redirect_to articles_path
    else
      complements = Complement.where(id: params[:complement][:complements])

      @page_title = "Popust"

      start_date = DateTime.new(params[:complement]['start_date(1i)'].to_i, params[:complement]['start_date(2i)'].to_i, params[:complement]['start_date(3i)'].to_i, params[:complement]['start_date(4i)'].to_i ,params[:complement]['start_date(5i)'].to_i  )

      end_date = DateTime.new(params[:complement]['end_date(1i)'].to_i, params[:complement]['end_date(2i)'].to_i, params[:complement]['end_date(3i)'].to_i, params[:complement]['end_date(4i)'].to_i ,params[:complement]['end_date(5i)'].to_i  )


      if complements != nil
        complements.update_all(discount: params[:complement][:discount], start_date: start_date, end_date: end_date )
      end

      redirect_to complements_path

    end
  end
  #####################  #####################  #####################  #####################

  #####################  #####################  #####################  ##################### aukcije

  def set_auction

    if params[:articles]
      @art = Article.where(id: params[:articles][:selected])

      @art_ids = []

      @codes = Article.select(:code).map(&:code)

      @art.each do |a|
        @art_ids.push(a.id)
      end

    elsif params[:complements]
      @comp = Complement.where(id: params[:complements][:selected])

      @comp_ids = []

      @comp.each do |a|
        @comp_ids.push(a.id)
      end

    end


  end


  def index_auction
    @auction_articles = Auction.all

    @auction_grid = initialize_grid(@auction_articles, name: 'auction', include: [ {article: :picture}, :complement, :user ] ,order: 'auctions.created_at', order_direction: 'desc', enable_export_to_csv: true, csv_file_name: 'artikli na aukciji', csv_field_separator: ';' )

  end


  def create_auction

      start_date = DateTime.new(params[:article]['start_date(1i)'].to_i, params[:article]['start_date(2i)'].to_i, params[:article]['start_date(3i)'].to_i, params[:article]['start_date(4i)'].to_i ,params[:article]['start_date(5i)'].to_i  )

      end_date = DateTime.new(params[:article]['end_date(1i)'].to_i, params[:article]['end_date(2i)'].to_i, params[:article]['end_date(3i)'].to_i, params[:article]['end_date(4i)'].to_i ,params[:article]['end_date(5i)'].to_i  )


      if params[:article][:articles]
        articles = Article.where(id: params[:article][:articles])

        if params[:article][:codes].length > 1
          articles_codes = Article.where(code: params[:article][:codes])
        end

        if articles != nil
          articles.each do |a|
            puts "#{a.title}"
            Auction.create(article_id: a.id, starting_price: params[:article][:starting_price], start_date: start_date, end_date: end_date )
          end
        end

        if articles_codes != nil
          articles_codes.each do |art|
            Auction.create(article_id: art.id, starting_price: params[:article][:starting_price], start_date: start_date, end_date: end_date )
          end
        end

      else
        complements = Complement.where(id: params[:article][:complements])

        complements.each do |art|
          Auction.create(complement_id: art.id, starting_price: params[:article][:starting_price], start_date: start_date, end_date: end_date )
        end
      end

      redirect_to index_auction_path
  end



  #####################  #####################  #####################  #####################


  #####################  #####################  #####################  ##################### funkcije za editiranje i update-anje vise artikla
  def edit_multiple

    if params[:articles]
      $art = Article.where(id: params[:articles][:selected])
      @codes = Article.where()
    else
      $art = Article.where(id: params[:raw][:selected])
    end
  end


  def update_multiple #kada sam ovo pisao samo Bog i ja smo znali kako to funkcionira...sada samo Bog zna...

    $art.each do |article|

      @articles_mult = Article.where(id: article.id)
      @param = params["articles"+article.id.to_s]

      @articles_mult.each do |art|

        art.title = @param[:title]

        art.title_eng = @param[:title_eng]

        if @param[:raw] == false
          art.material_id = @param[:material_id]
        else
          art.subcategory_id = @param[:subcategory_id]

          art.ssubcategory_id =  @param[:ssubcategory_id]
        end

        art.description = @param[:description]

        art.description_eng = @param[:description_eng]

        art.weight = @param[:weight]

        art.dimension = @param[:dimension]

        art.code = @param[:code]

        art.suppliers_code = @param[:suppliers_code]

        art.amount = @param[:amount]

        art.warning = @param[:warning]

        art.cost = @param[:cost]

        art.discount = @param[:discount]

        art.for_sale = @param[:for_sale]

        art.save

#################################################################### postavljanje kategorija
        ArticleCategory.destroy_all(article_id: article.id)

        if @param[:category_ids] != nil
          @param[:category_ids].each do |c|
            if c != "" && c != nil && ArticleCategory.where(article_id: article.id, category_id: c).empty?
              ArticleCategory.create(article_id: article.id, category_id: c)
            end
          end
        end

####################################################################

#################################################################### postavljanje srodnih artikla

        RelatedArticle.where(article_id: article.id).destroy_all
        RelatedArticle.where(related_article_id: article.id).destroy_all

        if @param[:related_articles][:related_article_ids]

          @param[:related_articles][:related_article_ids].each do |art_rel|

            if !art_rel.empty?
              RelatedArticle.create(article_id: article.id, related_article_id: art_rel)
              RelatedArticle.create(article_id: art_rel, related_article_id: article.id)
            end
          end
        end

        if @param[:related_articles][:related_article_codes]

          arts = Article.where(code: @param[:related_articles][:related_article_codes])

          arts.each do |art_rel|

            if !art_rel.code.blank?
              RelatedArticle.create(article_id: article.id, related_article_id: art_rel.id)
              RelatedArticle.create(article_id: art_rel.id, related_article_id: article.id)
            end
          end

        end
####################################################################

      end

      @single = params["articles"+article.id.to_s][:single_articles_attributes] != nil ? params["articles"+article.id.to_s][:single_articles_attributes].values : nil

      if @single != nil
        @single.each do |s|

          if !s["color_id"].blank?
            col =  Color.find(s["color_id"])
          end


        if s["id"] == nil

         sa = SingleArticle.new

############################################################### postavljanje naziva pojedinacnog artikla
         sa.title = article.title
         sa.code = article.code

         if s["type_name"] != nil && s["type_name"] != ""
           sa.title += "/"+s["type_name"].to_s
           sa.code += "-"+s["type_name"][0,2].upcase
         end

         if sa.color != nil && sa.color != ""
           sa.title += "/"+col.title
           sa.code += "-"+col.title[0,2].upcase
         end

         if sa.size != nil && sa.size != ""
           sa.title += "/"+s["size"].to_s
           sa.code += "-"+s["size"].to_s
         end

         if s["amont"] == nil || s["amont"] == ""
           sa.amount = article.amount
         else
           sa.amount = s["amont"]
         end

         if s["warning"] == nil || s["warning"] == ""
           sa.warning = article.warning
         else
           sa.warning = s["warning"]
         end
###############################################################


         sa.article_id = article.id
         sa.color_id = col != nil ? col.id : nil
         sa.size = s["size"]
         sa.type_name = s["type_name"]
         sa.save

        else
         sa = SingleArticle.find( s["id"])


         if s["_destroy"] == "1"
           sa.destroy
         else

############################################################### postavljanje naziva artikla
             sa.title = article.title
             sa.code = article.code

         if s["type_name"] != nil && s["type_name"] != ""
           sa.title += "/"+s["type_name"].to_s
           sa.code += "-"+s["type_name"][0,2].upcase
         end

           if sa.color != nil && sa.color != ""
             sa.title += "/"+col.title
             sa.code += "-"+col.title[0,2].upcase
           end

           if sa.size != nil && sa.size != ""
             sa.title += "/"+s["size"].to_s
             sa.code += "-"+s["size"].to_s
           end

             if s["amont"] == nil || s["amont"] == ""
               sa.amount = article.amount
             else
               sa.amount = s["amount"]
             end

             if s["warning"] == nil || s["warning"] == ""
               sa.warning = article.warning
             else
               sa.warning = s["warning"]
             end
###############################################################

           sa.color_id = col != nil ? col.id : nil
           sa.size = s["size"]
           sa.type_name = s["type_name"]
           sa.save
         end
          end
        end
      end


      @articles_mult.each do |art|

        @index = 0

      if params["images"+art.id.to_s]
        #===== The magic is here
        params["images"+art.id.to_s].each do |image|

            art.pictures.create(image: image)

        end
      end

      art.single_articles.each do |sa|

        image = params["articles"+art.id.to_s][:single_articles_attributes].values[@index]

        if image[:pictures]!= nil
          image[:pictures].each do |pic|
            sa.pictures.create(image: pic)
          end
        end

        @index += 1
      end

      end

    end

    flash[:notice] = "Artikli su izmijenjeni!"

    if @param[:raw] == "false"
      redirect_to articles_path
    else
      redirect_to raw_index_path
    end
  end

  #####################  #####################  #####################  #####################

  #####################  #####################  #####################  ##################### repromaterijal


  def raw_index
    @page_title = "Repromaterijal"
    @raw = Article.where(raw: true)
    @raw_grid = initialize_grid(@raw, name: 'raw', include: [:subcategory, :ssubcategory, :pictures] ,order: 'articles.created_at', order_direction: 'desc', enable_export_to_csv: true, csv_file_name: 'repromaterijal', csv_field_separator: ';' )

    export_grid_if_requested
  end

  def raw_new
    @raw = Article.new
  end


  #####################  #####################  #####################  #####################

  def set_picture # postavljanje avatar-a za artikl

    @pic = Picture.find(params[:format])


    if @pic.article != nil
      @art = Article.find(@pic.article.id)
    elsif @pic.single_article != nil
      @art = Article.find(@pic.single_article.article.id)
    end

    @art.picture = @pic

    @art.save

    redirect_to(:back)
  end

  protected
    def article_params
      params.require(:article).permit(:title, :raw, :dimension, :subcategory_id, :ssubcategory_id, {related_article_ids:[]} ,:title_eng, :start_date, :end_date, :description_eng, :discount,  :material_id , {category_ids:[]} , :code, :type_id,  :weight, :cost, :description, :amount, :suppliers_code, :warning, :for_sale , :color, single_articles_attributes: [:id, :type_name, :color_id, :size, :title, :article_id, :_destroy])
    end

    def csv_params
      params.require(:csv_upload).permit(:document)
    end

end





















