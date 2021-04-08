class LinksController < ApplicationController
  def new
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)
    if @link.save
      redirect_to admin_path(admin_slug: @link.admin_slug)
    else
      flash[:alert] = "Invalid URL"
      redirect_to root_path
    end
  end

  def admin
  end

  private

  def link_params
    params.require(:link).permit(:original_url)
  end
end