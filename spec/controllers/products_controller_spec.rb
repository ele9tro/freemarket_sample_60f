require 'rails_helper'

describe ProductsController do

  describe 'GET #index' do

    it "indexビューが呼ばれているか" do
      get :index
      expect(response).to render_template :index
    end

    it "@productsに正しい値が入っているか" do
      products = create_list(:product, 3)
      get :index
      expect(assigns(:products)).to match(products.sort{ |a, b| b.created_at <=> a.created_at })
    end

  end

end