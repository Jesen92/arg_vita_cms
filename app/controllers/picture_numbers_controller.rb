class PictureNumbersController < ApplicationController
  before_action :set_picture_number, only: [:show, :edit, :update, :destroy]

  # GET /picture_numbers
  # GET /picture_numbers.json
  def index
    @picture_numbers = PictureNumber.all
  end

  # GET /picture_numbers/1
  # GET /picture_numbers/1.json
  def show
  end

  # GET /picture_numbers/new
  def new
    @picture_number = PictureNumber.new
  end

  # GET /picture_numbers/1/edit
  def edit
  end

  # POST /picture_numbers
  # POST /picture_numbers.json
  def create
    @picture_number = PictureNumber.new(picture_number_params)

    respond_to do |format|
      if @picture_number.save
        format.html { redirect_to @picture_number, notice: 'Picture number was successfully created.' }
        format.json { render :show, status: :created, location: @picture_number }
      else
        format.html { render :new }
        format.json { render json: @picture_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /picture_numbers/1
  # PATCH/PUT /picture_numbers/1.json
  def update
    respond_to do |format|
      if @picture_number.update(picture_number_params)
        format.html { redirect_to @picture_number, notice: 'Picture number was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture_number }
      else
        format.html { render :edit }
        format.json { render json: @picture_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /picture_numbers/1
  # DELETE /picture_numbers/1.json
  def destroy
    @picture_number.destroy
    respond_to do |format|
      format.html { redirect_to picture_numbers_url, notice: 'Picture number was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture_number
      @picture_number = PictureNumber.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_number_params
      params.require(:picture_number).permit(:title)
    end
end
