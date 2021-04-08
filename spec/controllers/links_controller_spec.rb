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
end