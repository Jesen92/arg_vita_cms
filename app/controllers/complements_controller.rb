class ComplementsController < ApplicationController

  def index
    @page_title = "Kompleti"
    @complements = Complement.all
    @complements_grid = initialize_grid(@complements, name: 'complements', include: [ :picture] ,order: 'complements.created_at', order_direction: 'desc', enable_export_to_csv: true, csv_file_name: 'kompleti', csv_field_separator: ';' )

    export_grid_if_requested
  end

  def show
    @complement = Complement.find(params[:id])
    @page_title = "Kompleti | " + (@complement.title)

    @discount_prize = nil

    if @complement.end_date != nil
      gon.date = @complement.end_date.strftime("%Y/%m/%d %H:%M")
    end

    if @complement.discount != nil && @complement.discount != 0
      @discount_prize = (@complement.cost-(@complement.cost*@complement.discount/100))
    end
  end

  def new
    @complement = Complement.new
    @page_title = "Kompleti | New"

    @codes = Article.select(:code).map(&:code)
  end

  def create
    @complement = Complement.new(complement_params)

    if @complement.save

      if params[:images]

        params[:images].each { |image|
          @complement.pictures.create(image: image)
        }
      end
    end

    if @complement.pictures != nil && @complement.pictures.first != nil
      @complement.picture = @complement.pictures.first
    end

    flash[:notice] = "Dodan je novi komplet!"

    redirect_to complements_index_path
  end

  def edit
    @complement = Complement.find(params[:format])
    @page_title = "Kompleti | " + @complement.title
  end

  def update
    @complement = Complement.find(params[:id])

    @complement.update(complement_params)

      if params[:images]

        params[:images].each { |image|
          @complement.pictures.create(image: image)
        }
      end

    flash[:notice] = "Komplet je izmijenjen!"

    redirect_to complements_index_path
  end

  def destroy
    @complement = Complement.find(params[:id])

    @complement.destroy

    flash[:notice] = "Komplet je izbrisan!"

    redirect_to complements_index_path
  end

  ###################################################################### batch actions
  def complement_batch_actions


  end

  ################################################## discount i auction

  def complement_discount
    @comp = Complement.where(id: params[:grid][:selected])
  end

  def complement_auction
    @comp = Complement.where(id: params[:grid][:selected])
  end

  ################################################################################

  def complement_set_picture # postavljanje avatar-a za artikl

    @pic = Picture.find(params[:format])

    if @pic.complement != nil
      @art = Complement.find(@pic.complement.id)
    end

    @art.picture = @pic

    @art.save

    redirect_to(:back)
  end


  protected
  def complement_params
    params.require(:complement).permit(:title, :title_eng, {single_article_ids:[] }, :description, :description_eng, :cost, :start_date, :end_date)
  end
end
