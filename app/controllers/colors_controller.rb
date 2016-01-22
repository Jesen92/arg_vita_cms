class ColorsController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @page_title = "Boje"
    @colors = Color.all
  end

  def show
    @color = Color.find(params[:id])
    @page_title = "Boje | " + @color.title
  end

  def new
    @color = Color.new
    @page_title = "Boja | New"
  end

  def create
    @color = Color.new(color_params)

    @color.save

    flash[:notice] = "Dodana je nova boja!"

    redirect_to colors_index_path
  end

  def edit
    @color = Color.find(params[:format])
    @page_title = "Boja | "+ @color.title
  end

  def update
    @color = Color.find(params[:id])

    @color.update(color_params)

    flash[:notice] = "Boja je izmijenjena!"

    redirect_to colors_index_path
  end

  def destroy
    @color = Color.find(params[:id])

    @color.destroy

    flash[:notice] = "Boja je izbrisana"

    redirect_to colors_index_path
  end

  protected
  def color_params
    params.require(:color).permit(:title ,:title_eng, :avatar )
  end
end

