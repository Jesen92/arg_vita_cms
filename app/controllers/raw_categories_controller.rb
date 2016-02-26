class RawCategoriesController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @page_title = "Kategorije"
    @subcategories = Subcategory.all
    @ssubcategories = Ssubcategory.all
  end

  def show
    @subcategory = Subcategory.find(params[:format])
    @page_title = "Kategorije | " + @subcategory.title
  end

  def new
    @subcategory = Subcategory.new
    @page_title = "Kategorije | New"
  end

  def create
    @subcategory = Subcategory.new(subcategory_params)

    @subcategory.save

    flash[:notice] = "Dodan je novi materijal!"

    redirect_to raw_categories_index_path
  end

  def edit
    @raw_category = Subcategory.find(params[:format])
    @page_title = "Edit | "+@raw_category.title
  end

  def update
    @subcategory = Subcategory.find(params[:id])

    @subcategory.update(subcategory_params)

    flash[:notice] = "Materijal je izmijenjen!"

    redirect_to raw_categories_index_path
  end

  def destroy
    @subcategory = Subcategory.find(params[:format])

    @subcategory.destroy

    flash[:notice] = "Kategorija za repromaterijal je izbrisana!"

    redirect_to raw_categories_index_path
  end

  protected
  def subcategory_params
    params.require(:subcategory).permit(:title,:title_eng, { ssubcategory_ids:[]}, :has_colors, :has_types)
  end
end
