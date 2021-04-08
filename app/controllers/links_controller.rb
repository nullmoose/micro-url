class LinksController < ApplicationController
  before_action :assign_link, only: [:admin, :expire, :show]

  def show
    @link.increment!(:click_counter)
    redirect_to @link.original_url
  end

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
    flash[:notice] = "Link has been expired"
    redirect_to root_path
  end

  private

  def link_params
    params.require(:link).permit(:original_url)
  end

  def assign_link
    slug = params[:short_slug] || params[:admin_slug]
    @link = Link.unexpired.find_by("short_slug = ? OR admin_slug = ?", slug, slug) or not_found
  end
end