class DashboardsController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    if current_admin_user
      @page_title = "Dashboard"
      @articles = Article.where("amount <= warning")
      @single_articles = SingleArticle.where("single_articles.amount <= single_articles.warning")

      @purchases = PastPurchase.where("past_purchases.article_sent = false AND past_purchases.article_id IS NOT NULL")
      @single_article_purchases = PastPurchase.where("past_purchases.article_sent = false AND past_purchases.single_article_id IS NOT NULL")
      @complement_purchases = PastPurchase.where("past_purchases.article_sent = false AND past_purchases.complement_id IS NOT NULL")

      @articles_limit_grid = initialize_grid(@articles, include: [:categories, :material], name: 'artiklizalihe', order: 'articles.created_at', order_direction: 'desc', per_page: 5, enable_export_to_csv: true, csv_file_name: 'artikli pred istekom zaliha', csv_field_separator: ';' )

      @single_articles_limit_grid = initialize_grid(@single_articles, include: [  :pictures ,:color, :article], name: 'pojedinacniartiklizalihe', order: 'single_articles.created_at', order_direction: 'desc', per_page: 5, enable_export_to_csv: true, csv_file_name: 'pojedinacni artikli pred istekom zaliha', csv_field_separator: ';' )

      @purchases_grid = initialize_grid(@purchases, include: [:user ,:article], name: 'kupnje', order: 'past_purchases.created_at', order_direction: 'desc', per_page: 10, enable_export_to_csv: true, csv_file_name: 'Kupnje', csv_field_separator: ';' )

      @single_article_purchases_grid = initialize_grid(@single_article_purchases, include: [ :single_article, :user ], name: 'pakupnje', order: 'past_purchases.created_at', order_direction: 'desc', per_page: 10, enable_export_to_csv: true, csv_file_name: 'Kupnje', csv_field_separator: ';' )

      @complement_purchases_grid = initialize_grid(@complement_purchases, include: [ :complement, :user ], name: 'kompkupnje', order: 'past_purchases.created_at', order_direction: 'desc', per_page: 10, enable_export_to_csv: true, csv_file_name: 'Kupnje', csv_field_separator: ';' )



      export_grid_if_requested
    else
      redirect_to new_admin_user_session_path, notice: 'You are not logged in!'
    end
  end

  def show
  end


  def batch_options
    if params[:commit] == 'Izbriši prodaje'

      if params[:kupnje]
        PastPurchase.destroy_all(id: params[:kupnje][:selected])
      end

      if params[:pakupnje]
        PastPurchase.destroy_all(id: params[:pakupnje][:selected])
      end

      if params[:kompkupnje]
        PastPurchase.destroy_all(id: params[:kompkupnje][:selected])
      end

    elsif params[:commit] == 'Artikli poslani!'

      if params[:kupnje]
        pp = PastPurchase.where(id: params[:kupnje][:selected])
        pp.update_all(article_sent: true)
      end

      if params[:pakupnje]
        pp = PastPurchase.where(id: params[:pakupnje][:selected])
        pp.update_all(article_sent: true)
      end

      if params[:kompkupnje]
        pp = PastPurchase.where(id: params[:kompkupnje][:selected])
        pp.update_all(article_sent: true)
      end

    elsif params[:commit] == 'Artikli nisu poslani!'

      if params[:kupnje]
        pp = PastPurchase.where(id: params[:kupnje][:selected])
        pp.update_all(article_sent: false)
      end

      if params[:pakupnje]
        pp = PastPurchase.where(id: params[:pakupnje][:selected])
        pp.update_all(article_sent: false)
      end

      if params[:kompkupnje]
        pp = PastPurchase.where(id: params[:kompkupnje][:selected])
        pp.update_all(article_sent: false)
      end

    end

    redirect_to root_path
  end


end
