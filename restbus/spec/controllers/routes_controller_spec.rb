require 'rails_helper'

RSpec.describe RoutesController, type: :controller do
  describe 'GET #index' do
    before do
      get :index, agency_id: agency_id
    end

    context 'with valid agency' do
      let(:agency_id) { 'ttc' }

      it 'succeeds' do
        expect(response).to have_http_status(200)
      end

      it 'returns a json object with ids' do
        JSON
          .parse(response.body)
          .map { |item| item['id'] }
          .each { |id| expect(id).to be_a String }
      end

      describe 'GET #show' do
        before do
          get :show, agency_id: agency_id, id: route_id
        end

        context 'with valid route_id' do
          let(:route_id) { 53 }

          it 'succeeds' do
            expect(response).to have_http_status(200)
          end

          it 'returns a json object with id' do
            expect(JSON.parse(response.body)['id']).to eq('53')
          end
        end

        context 'with invalid route_id' do
          let(:route_id) { 'does_not_exist' }

          it 'fails' do
            expect(response).to have_http_status(404)
          end
        end
      end
    end

    context 'with invalid agency' do
      let(:agency_id) { 'foobar' }

      describe 'GET #index' do
        before do
          get :index, agency_id: agency_id
        end

        it 'fails' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
