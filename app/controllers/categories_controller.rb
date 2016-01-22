class CategoriesController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @page_title = "Kategorije"
    @categories = Category.all

    @subcategories = Subcategory.all
  end

  def show
    @category = Category.find(params[:id])
    @page_title = "Kategorije | " + @category.title
  end

  def new
    @category = Category.new
    @page_title = "Kategorije | New"
  end

  def create
    @category = Category.new(category_params)

    @category.save

    flash[:notice] = "Dodan je novi materijal!"

    redirect_to categories_index_path
  end

  def edit
    @category = Category.find(params[:format])
    @page_title = "Edit | "+@category.title
  end

  def update
    @category = Category.find(params[:id])

    @category.update(category_params)

    flash[:notice] = "Materijal je izmijenjen!"

    redirect_to categories_index_path
  end

  def destroy
    @category = Category.find(params[:id])

    @category.destroy

    flash[:notice] = "Materijal je izbrisan!"

    redirect_to categories_index_path
  end

  protected
  def category_params
    params.require(:category).permit(:title,:title_eng,  material_ids:[])
  end
end
