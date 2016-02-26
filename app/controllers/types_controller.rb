class TypesController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @page_title = "Tipovi"
    @types = Type.all
  end

  def show
    @type = Type.find(params[:id])
    @page_title = "Tipovi | " + @type.title
  end

  def new
    @type = Type.new
    @page_title = "Tip | New"
  end

  def create
    @type = Type.new(type_params)

    @type.save

    flash[:notice] = "Dodan je novi tip!"

    redirect_to types_index_path
  end

  def edit
    @type = Type.find(params[:format])
    @page_title = "Tip | "+ @type.title
  end

  def update
    @type = Type.find(params[:id])

    @type.update(type_params)

    flash[:notice] = "Tip je izmijenjen!"

    redirect_to types_index_path
  end

  def destroy
    @type = Type.find(params[:id])

    @type.destroy

    flash[:notice] = "Tip je izbrisan"

    redirect_to types_index_path
  end

  protected
  def type_params
    params.require(:type).permit(:title ,:title_eng )
  end
end
