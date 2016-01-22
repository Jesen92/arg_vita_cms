class PicturesController < ApplicationController
  def edit
  end

  def update
  end

  def destroy
    @picture = Picture.find(params[:id])

    id = @picture.article_id

    @picture.destroy


    flash[notice] = "Slika je obrisana"

    redirect_to(:back)
  end
end
