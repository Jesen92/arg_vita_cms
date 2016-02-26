class MaterialsController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @materials = Material.all
    @page_title = "Materijali"
  end

  def show
    @material = Material.find(params[:id])
    @page_title = "Materijali | " + @material.title
  end

  def new
    @material = Material.new
    @page_title = "Materijali | New"
  end

  def create
    @material = Material.new(material_params)

    @material.save

    flash[:notice] = "Dodan je novi materijal!"

    redirect_to materials_index_path
  end

  def edit
    @material = Material.find(params[:format])
    @page_title = "Materijali | " + @material.title
  end

  def update
    @material = Material.find(params[:id])

    @material.update(material_params)

    flash[:notice] = "Materijal je izmijenjen!"

    redirect_to materials_index_path
  end

  def destroy
    @material = Material.find(params[:id])

    @material.destroy

    flash[:notice] = "Materijal je izbrisan!"

    redirect_to materials_index_path
  end

  protected
  def material_params
    params.require(:material).permit(:title,:title_eng, {category_ids:[]}, :avatar, :has_colors, :has_types)
  end
end
