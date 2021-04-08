require 'rails_helper'

RSpec.describe LinksController do
  let(:link) { Link.create(original_url: "https://www.test.com") }

  describe "GET show" do
    it "assigns @link by short_slug" do
      get :show, params: { short_slug: link.short_slug }
      expect(assigns(:link)).to eq(link)
    end

    it "redirects to the original_url" do
      get :show, params: { short_slug: link.short_slug }
      expect(response).to redirect_to(link.original_url)
    end

    it "increments the click_counter for the link" do
      expect {
        get :show, params: { short_slug: link.short_slug }
        link.reload
      }.to change { link.click_counter }.by(1)
    end

    it "raises a not found error when link does not exist" do
      expect {
        get :show, params: { short_slug: "bad_slug" }
      }.to raise_error(ActionController::RoutingError)
    end

    it "raises a not found error for expired links" do
      link.update(expired: true)
      expect {
        get :show, params: { short_slug: link.short_slug }
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET new" do
    it "assigns @link" do
      get :new
      expect(assigns(:link)).to be_a_new(Link)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    let(:link_attributes) do
      {
        original_url: "https://www.test.com"
      }
    end

    it "assigns @link" do
      post :create, params: { link: link_attributes }
      expect(assigns(:link).original_url).to eq(link_attributes[:original_url])
    end

    context "valid link" do
      it "creates a new link" do
        expect {
          post :create, params: { link: link_attributes }
        }.to change(Link, :count).by(1)
      end

      it "redirects to the admin action" do
        post :create, params: { link: link_attributes }
        expect(response).to redirect_to(admin_path(assigns(:link).admin_slug))
      end
    end

    context "invalid link" do
      before do
        allow_any_instance_of(Link).to receive(:save).and_return(false)
      end

      it "redirects to the new action" do
        post :create, params: { link: link_attributes }
        expect(response).to redirect_to(root_path)
      end

      it "notifies the user that the link is invalid" do
        post :create, params: { link: link_attributes }
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET admin" do
    let(:link) { Link.create(original_url: "https://www.test.com") }

    it "assigns @link by admin_slug" do
      get :admin, params: { admin_slug: link.admin_slug }
      expect(assigns(:link)).to eq(link)
    end

    it "renders the admin view" do
      get :admin, params: { admin_slug: link.admin_slug }
      expect(response).to render_template(:admin)
    end

    it "raises a not found error when link does not exist" do
      expect {
        get :admin, params: { admin_slug: "bad_slug" }
      }.to raise_error(ActionController::RoutingError)
    end

    it "raises a not found error for expired links" do
      link.update(expired: true)
      expect {
        get :admin, params: { admin_slug: link.admin_slug }
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "PUT expire" do
    let(:link) { Link.create(original_url: "https://www.test.com") }

    it "assigns @link by admin_slug" do
      put :expire, params: { admin_slug: link.admin_slug }
      expect(assigns(:link)).to eq(link)
    end

    it "expires the link" do
      expect {
        put :expire, params: { admin_slug: link.admin_slug }
        link.reload
      }.to change { link.expired }.from(false).to(true)
    end

    it "redirects to the new action" do
      put :expire, params: { admin_slug: link.admin_slug }
      expect(response).to redirect_to(root_path)
    end

    it "notifies the user that the link has been expired" do
      put :expire, params: { admin_slug: link.admin_slug }
      expect(flash[:notice]).to be_present
    end

    it "raises a not found error when link does not exist" do
      expect {
        get :expire, params: { admin_slug: "bad_slug" }
      }.to raise_error(ActionController::RoutingError)
    end

    it "raises a not found error for expired links" do
      link.update(expired: true)
      expect {
        get :expire, params: { admin_slug: link.admin_slug }
      }.to raise_error(ActionController::RoutingError)
    end
  end
end