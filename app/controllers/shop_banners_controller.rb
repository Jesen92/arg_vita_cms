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

    @max_order = ShopBanner.maximum("order").to_i+1

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

  ################################################ pomicanje redoslijeda banner-a

  def banner_up

    @banner = ShopBanner.find(params[:id])

    if @banner.order-1 > 0

      @banner_change = ShopBanner.find_by(order: @banner.order-1)

      @banner.order -= 1

      @banner_change.order +=1

      @banner.save
      @banner_change.save

    else

      flash[:notice] = "Banner je prvi po redoslijedu!"

    end

    redirect_to :back

  end

  def banner_down
    @banner = ShopBanner.find(params[:id])

    if @banner.order+1 <= ShopBanner.maximum("order")

      @banner_change = ShopBanner.find_by(order: @banner.order+1)

      @banner.order += 1

      @banner_change.order -=1

      @banner.save
      @banner_change.save

    else

      flash[:notice] = "Banner je zadnji po redoslijedu!"

    end

    redirect_to :back

  end

  ################################################

  protected
  def banner_params
    params.require(:shop_banner).permit(:title ,:order, :image, :active)
  end
end
