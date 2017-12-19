require 'rails_helper'

RSpec.describe NearbyController, type: :controller do

  describe "GET #index" do
    context 'without longitude and latitude' do
      it 'fails' do
        get :index

        expect(response).to have_http_status(400)
      end
    end

    context 'without latitude' do
      it 'fails' do
        get :index, { longitude: 50 }
        expect(response).to have_http_status(400)
      end
    end

    context 'without longitude' do
      it 'fails' do
        get :index, { latitude: 50 }
        expect(response).to have_http_status(400)
      end
    end

    context 'with longitude and latitude' do
      it "returns http success" do
        get :index, { longitude: 50, latitude: 40 }

        expect(response).to have_http_status(:success)
      end
    end
  end
end
