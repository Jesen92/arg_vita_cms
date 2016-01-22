class DashboardsController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    if current_admin_user
      @page_title = "Dashboard"
      @articles = Article.where("amount <= warning")

      @articles_limit_grid = initialize_grid(@articles, include: [:categories, :material], name: 'artikli_zalihe', order: 'articles.created_at', order_direction: 'desc', per_page: 5, enable_export_to_csv: true, csv_file_name: 'artikli pred istekom zaliha', csv_field_separator: ';' )

      export_grid_if_requested
    else
      redirect_to new_admin_user_session_path, notice: 'You are not logged in!'
    end
  end

  def show
  end
end
