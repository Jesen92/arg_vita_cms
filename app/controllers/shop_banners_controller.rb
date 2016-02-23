class ShopBannersController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @page_title = "Boje"
    @banners = ShopBanner.all
  end

  def show
    @banner = ShopBanner.find(params[:id])
    @page_title = "Boje | " + @banner.title
  end

  def new
    @banner = ShopBanner.new
    @page_title = "ShopBanner | New"
  end

  def create
    @banner = ShopBanner.new(banner_params)

    @banner.save

    flash[:notice] = "Dodana je nova boja!"

    redirect_to shop_banners_index_path
  end

  def edit
    @banner = ShopBanner.find(params[:format])
    @page_title = "ShopBanner | "+ @banner.title
  end

  def update
    @banner = ShopBanner.find(params[:id])

    @banner.update(banner_params)

    flash[:notice] = "ShopBanner je izmijenjen!"

    redirect_to shop_banners_index_path
  end

  def destroy
    @banner = ShopBanner.find(params[:id])

    @banner.destroy

    flash[:notice] = "ShopBanner je izbrisan"

    redirect_to shop_banners_index_path
  end

  protected
  def banner_params
    params.require(:shop_banner).permit(:title ,:order, :image, :active)
  end
end
