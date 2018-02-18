require 'rails_helper'

RSpec.describe PredictionsController, type: :controller do
  describe 'GET #index' do
    before do
      get :index, agency_id: agency_id, route_id: route_id, stop_id: stop_id
    end

    context 'with valid agency' do
      let(:agency_id) { 'ttc' }

      context 'with valid route_id' do
        let(:route_id) { 53 }

        context 'with valid stop_id' do
          let(:stop_id) { 14204 }

          it 'succeeds' do
            expect(response).to have_http_status(200)
          end

          it 'returns a valid json object' do
            body = JSON.parse(response.body)

            expect(body.count).to eq(1)
            expect(body[0]['agency']['id']).to eq('ttc')
            expect(body[0]['route']['id']).to eq('53')
            expect(body[0]['stop']['id']).to eq('14204')
            expect(body[0]['values'].count).to be > 0
          end
        end
      end
    end
  end
end
