class PurchasesController < ApplicationController
  def index

    @page_title = "Prodaje"

    @purchases = UsersPurchase.all

    @purchases_grid = initialize_grid(@purchases, include: [ :user ], name: 'kompkupnje', order: 'users_purchases.created_at', order_direction: 'desc', per_page: 10, enable_export_to_csv: true, csv_file_name: 'Kupnje', csv_field_separator: ';' )

    export_grid_if_requested
  end

  def show
    @purchase_info = UsersPurchase.find(params[:id]);
    
    @article_purchases = PastPurchase.where(["past_purchases.users_purchase_id = ? AND past_purchases.article_id IS NOT NULL", @purchase_info.id])
    @single_article_purchases = PastPurchase.where(["past_purchases.users_purchase_id = ? AND past_purchases.single_article_id IS NOT NULL", @purchase_info.id])
    #@complement_purchases = PastPurchase.where("past_purchases.complement_id IS NOT NULL")
    @purchases_grid = initialize_grid(@article_purchases, include: [:user ,:article], name: 'kupnje', order: 'past_purchases.created_at', order_direction: 'desc', per_page: 10, enable_export_to_csv: true, csv_file_name: 'Kupnje', csv_field_separator: ';' )
    @single_article_purchases_grid = initialize_grid(@single_article_purchases, include: [ :single_article, :user ], name: 'pakupnje', order: 'past_purchases.created_at', order_direction: 'desc', per_page: 10, enable_export_to_csv: true, csv_file_name: 'Kupnje', csv_field_separator: ';' )
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
