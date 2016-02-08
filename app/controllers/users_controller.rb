class UsersController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @page_title = "Korisnici"
    @users = User.all
    @users_grid = initialize_grid(@users, order: 'users.created_at', order_direction: 'desc' )
  end

  def show
    @user = User.find(params[:format])
    @page_title = "Korisnik | " + (@user.name)

    @purchases = PastPurchase.where("past_purchases.user_id = #{params[:format]} AND past_purchases.article_id IS NOT NULL")
    @single_article_purchases = PastPurchase.where("past_purchases.user_id = #{params[:format]} AND past_purchases.single_article_id IS NOT NULL")
    @complement_purchases = PastPurchase.where("past_purchases.user_id = #{params[:format]} AND past_purchases.complement_id IS NOT NULL")

    @purchases_grid = initialize_grid(@purchases, include: [:user ,:article], name: 'kupnje', order: 'past_purchases.created_at', order_direction: 'desc', per_page: 10, enable_export_to_csv: true, csv_file_name: 'Kupnje', csv_field_separator: ';' )

    @single_article_purchases_grid = initialize_grid(@single_article_purchases, include: [ :single_article, :user ], name: 'pakupnje', order: 'past_purchases.created_at', order_direction: 'desc', per_page: 10, enable_export_to_csv: true, csv_file_name: 'Kupnje', csv_field_separator: ';' )

    @complement_purchases_grid = initialize_grid(@complement_purchases, include: [ :complement, :user ], name: 'kompkupnje', order: 'past_purchases.created_at', order_direction: 'desc', per_page: 10, enable_export_to_csv: true, csv_file_name: 'Kupnje', csv_field_separator: ';' )


    export_grid_if_requested
  end

  def new
    @user = User.new
    @page_title = "Korisnici | New"
  end

  def create
    @user = User.new(user_params)

    @user.save

    flash[:notice] = "Dodan je novi Korisnik!"

    redirect_to users_index_path
  end

  def edit
    @user = User.find(params[:id])
    @page_title = "Korisnici | Uredi"
  end

  def update
    @user = User.find(params[:id])

    @user.update(user_params)

    flash[:notice] = "Korisnik je izmijenjen!"

    redirect_to users_index_path
  end

  def destroy
    @user = User.find(params[:id])

    @user.destroy

    flash[:notice] = "Korisnik je izbrisan!"

    redirect_to users_index_path
  end

  protected
  def user_params
    params.require(:user).permit(:title, :article_id, :discount, :code)
  end
end
