require 'rails_helper'

RSpec.describe NearbyController, type: :controller do

  describe 'GET #index' do
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
      it 'returns http success' do
        get :index, { longitude: 50, latitude: 40 }

        expect(response).to have_http_status(:success)
      end

      context 'the body contains a JSON message' do
        subject { JSON.parse(response.body) }

        before do
          get :index, { longitude: 50, latitude: 40 }
        end

        it 'has the key latitude' do
          expect(subject).to have_key('latitude')
        end

        it 'has the key longitude' do
          expect(subject).to have_key('longitude')
        end

        it 'has the key schedule' do
          expect(subject).to have_key('schedule')
        end

        it 'has the key address' do
          expect(subject).to have_key('address')
        end
      end
    end
  end
end
