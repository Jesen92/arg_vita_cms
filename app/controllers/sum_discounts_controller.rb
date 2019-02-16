class SumDiscountsController < ApplicationController
  before_filter :authenticate_admin_user!
  before_filter :set_sum_discount, :only => [:edit, :update, :destroy]

  def index
    @sum_discounts = SumDiscount.all
    @sum_discounts_grid = initialize_grid(@sum_discounts ,order: 'sum_discounts.created_at', order_direction: 'desc' )
    @page_title = "Popusti"
  end

  def new
    @sum_discount = SumDiscount.new
    @page_title = "Popusti | New"
  end

  def create
    @sum_discount = SumDiscount.new(sum_discount_params)

    @sum_discount.save

    flash[:notice] = 'Dodan je novi Popust'

    redirect_to sum_discounts_path
  end

  def edit
    @page_title = "Popusti | Edit"
  end

  def update
    @sum_discount.update(sum_discount_params)

    flash[:notice] = "Popust je izmijenjen!"

    redirect_to sum_discounts_path
  end

  def destroy
    @sum_discount.destroy

    flash[:notice] = 'Popust je izbrisan!'

    redirect_to sum_discounts_path
  end

  private
  def set_sum_discount
    @sum_discount = SumDiscount.find(params[:id])
  end


  def sum_discount_params
    params.require(:sum_discount).permit(:sum ,:discount)
  end
end
