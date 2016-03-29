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
    @articles_grid = initialize_grid(@articles, name: 'articles', include: [ :categories ,:material, :pictures, :color, :type] ,order: 'articles.created_at', order_direction: 'desc', enable_export_to_csv: true, csv_file_name: 'artikli', csv_field_separator: ';' )

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

        CreateRelatedArticles.new(params[:article], @article).create_related_articles

        @index = 0

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


 #TODO create_related_articles service object treba ici tu!

    CreateRelatedArticles.new(params[:article], @article).create_related_articles


    @index = 0

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

    @codes = Article.select(:code).map(&:code)

    if params[:complements] ### batch_actions nad kompletima

         if params[:commit] == 'Stavi na Aukciju'
          return  redirect_to set_auction_path(params)
         else
           @indicator, @selected_ids, flash[:notice] = BatchActions.new(params).complements_batch_actions
         end

    else ### batch_actions nad artiklima

          if params[:commit] == 'Uredi odabrane artikle'
            @indicator = true
            return redirect_to edit_multiple_path(params)

          elsif params[:commit] == 'Izbriši aukcije'
            @art.destroy_all

            flash[:notice] = "Aukcije su izbrisane!"

            return redirect_to index_auction_path

          elsif params[:commit] == 'Stavi na Aukciju'

            @indicator = true
            return redirect_to set_auction_path(params)

          else
            @indicator, @selected_ids, flash[:notice] = BatchActions.new(params).articles_batch_action
          end

    end


    if params[:commit] = 'Izbriši artikle'
      return redirect_to :back
    end

 ########################### redirect-ovi
    if params[:articles]
      if params[:commit] != 'Postavi popust'
        if params[:articles] && @indicator == false
          return redirect_to articles_path
        elsif params[:raw] && @indicator == false
          return redirect_to raw_index_path
        elsif params[:article]
          return redirect_to index_auction_path
        end
      end
    elsif params[:complements]
      if params[:commit] != 'Postavi popust' && params[:commit] != 'Stavi na Aukciju'
        return redirect_to complements_path
      end
    end
    #########################

  end


  def set_discount #sluzi za postavljanje popusta nad vise artikla/kompleta

    @page_title = "Popust"

    if params[:article]

      #TODO service object set_discount nad artiklima

      SetDiscount.new(params).article_set_discount

      redirect_to articles_path
    else

      #TODO service object set_discount nad komletima

      SetDiscount.new(params).complement_set_discount

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

      Auction.new(params).create_auction

      flash[:notice] = "Izrađene nove aukcije!"

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


  def update_multiple

    $art.each do |article|

      @articles_mult = Article.where(id: article.id)
      @param = params["articles"+article.id.to_s]

      @articles_mult.each do |art|

        UpdateMultipleArticles.new(@param, art).update

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

        CreateRelatedArticles.new(@param, article).create_related_articles

####################################################################

      end

      @single = params["articles"+article.id.to_s][:single_articles_attributes] != nil ? params["articles"+article.id.to_s][:single_articles_attributes].values : nil

      if @single != nil
        @single.each do |s|

          UpdateMultipleSingleArticles.new(s, article).update

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
      params.require(:article).permit(:title, :raw, :short_description, :short_description_eng,:related_articles, :feature_product ,:dimension, :subcategory_id, :ssubcategory_id, {related_article_ids:[]} ,:title_eng, :start_date, :end_date, :description_eng, :discount,  :material_id , {category_ids:[]} , :code,  :weight, :cost, :description, :amount, :suppliers_code, :warning, :for_sale , :color_id, :type_id, single_articles_attributes: [:id, :amount, :warning, :type_name, :color_id, :size, :title, :article_id, :_destroy])
    end

    def csv_params
      params.require(:csv_upload).permit(:document)
    end

end





















