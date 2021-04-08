class LinksController < ApplicationController
  before_action :assign_link, only: [:admin, :expire]

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

  def expire
    @link.update(expired: true)
    redirect_to root_path
  end

  private

  def link_params
    params.require(:link).permit(:original_url)
  end

  def assign_link
    @link = Link.unexpired.find_by(admin_slug: params[:admin_slug]) or not_found
  end
end