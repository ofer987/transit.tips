require 'rails_helper'

RSpec.describe NearbyController, type: :controller do

  describe "GET #index" do
    context 'without longitude and latitude' do
      it 'fails' do
        expect do
          get :index
        end.to raise_error(RestClient::NotFound)
      end
    end

    context 'without latitude' do
      it 'fails' do
        expect do
          get :index, { longitude: 50 }
        end.to raise_error(RestClient::NotFound)
      end
    end

    context 'without longitude' do
      it 'fails' do
        expect do
          get :index, { latitude: 50 }
        end.to raise_error(RestClient::NotFound)
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
