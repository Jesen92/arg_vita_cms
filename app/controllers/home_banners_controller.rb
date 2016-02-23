class HomeBannersController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @page_title = "Boje"
    @banners = HomeBanner.all
  end

  def show
    @banner = HomeBanner.find(params[:id])
    @page_title = "Boje | " + @banner.title
  end

  def new
    @banner = HomeBanner.new
    @page_title = "HomeBanner | New"
  end

  def create
    @banner = HomeBanner.new(banner_params)

    @banner.save

    flash[:notice] = "Dodana je nova boja!"

    redirect_to home_banners_index_path
  end

  def edit
    @banner = HomeBanner.find(params[:format])
    @page_title = "HomeBanner | "+ @banner.title
  end

  def update
    @banner = HomeBanner.find(params[:id])

    @banner.update(banner_params)

    flash[:notice] = "HomeBanner je izmijenjen!"

    redirect_to home_banners_index_path
  end

  def destroy
    @banner = HomeBanner.find(params[:id])

    @banner.destroy

    flash[:notice] = "HomeBanner je izbrisan"

    redirect_to home_banners_index_path
  end

  protected
  def banner_params
    params.require(:home_banner).permit(:title ,:order, :image, :active)
  end
end
