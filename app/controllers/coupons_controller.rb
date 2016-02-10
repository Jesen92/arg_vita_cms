class CouponsController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @page_title = "Kuponi"
    @coupons = Coupon.all
    @coupons_grid = initialize_grid(@coupons, include: [:article] ,order: 'coupons.created_at', order_direction: 'desc' )
  end

  def show
    @coupon = Coupon.find(params[:id])
    @page_title = "Kuponi | " + (@coupon.article.nil? ? "Svi artikli" : @coupon.article.title)
  end

  def new
    @coupon = Coupon.new
    @page_title = "Kuponi | New"
  end

  def create
    @coupon = Coupon.new(coupon_params)

    @coupon.save

    flash[:notice] = "Dodan je novi materijal!"

    redirect_to coupons_index_path
  end

  def edit
    @coupon = Coupon.find(params[:id])
    @page_title = "Kuponi | Uredi"
  end

  def update
    @coupon = Coupon.find(params[:id])

    @coupon.update(coupon_params)

    flash[:notice] = "Kupon je izmijenjen!"

    redirect_to coupons_index_path
  end

  def destroy
    @coupon = Coupon.find(params[:id])

    @coupon.destroy

    flash[:notice] = "Kupon je izbrisan!"

    redirect_to coupons_index_path
  end

  def coupon_batch_actions
    @coup = Coupon.where(id: params[:grid][:selected]).destroy_all

    flash[:notice] = "Kuponi su izbrisani!"

    redirect_to coupons_path
  end

  protected
  def coupon_params
    params.require(:coupon).permit(:title, :article_id, :discount, :code)
  end
end













