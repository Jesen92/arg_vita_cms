class RawSubcategoriesController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @page_title = "Kategorije"
    @ssubcategory = Ssubcategory.all
  end

  def show
    @ssubcategory = Ssubcategory.find(params[:format])
    @page_title = "Kategorije | " + @ssubcategory.title
  end

  def new
    @ssubcategory = Ssubcategory.new
    @page_title = "Kategorije | New"
  end

  def create
    @ssubcategory = Ssubcategory.new(ssubcategory_params)

    @ssubcategory.save

    flash[:notice] = "Dodan je novi materijal!"

    redirect_to raw_categories_index_path
  end

  def edit
    @raw_subcategory = Ssubcategory.find(params[:format])
    @page_title = "Edit | "+@raw_subcategory.title
  end

  def update
    @ssubcategory = Ssubcategory.find(params[:id])

    @ssubcategory.update(ssubcategory_params)

    flash[:notice] = "Materijal je izmijenjen!"

    redirect_to raw_categories_index_path
  end

  def destroy
    @ssubcategory = Ssubcategory.find(params[:format])

    @ssubcategory.destroy

    flash[:notice] = "Podkategorija je izrađena!"

    redirect_to raw_categories_index_path
  end

  protected
  def ssubcategory_params
    params.require(:ssubcategory).permit(:title,:title_eng, :avatar ,subcategory_ids:[])
  end
end
