require 'rails_helper'

RSpec.describe LinksController do
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
end