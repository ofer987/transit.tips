require 'rails_helper'

RSpec.describe ReportController do
  context 'belongs to lines#show' do
    let(:status) { create(:status, line_id: 1, description: 'ALL CLEAR') }
    let(:line_id) { status.line_id }

    let(:query_general) { { line_id: line_id } }
    let(:query_specific) { {} }
    let(:query) { query_general.merge(query_specific) }

    context '#index' do
      it 'returns http status 200' do
        get :index, query

        expect(response).to have_http_status(:ok)
      end

      it 'returns a json message' do
        get :index, query

        expect(response.content_type).to eq('application/json')
      end

      it 'condition is green' do
        get :index, query

        condition =
          JSON.parse(response.body)['data']['attributes']['condition']
        expect(condition).to eq('green')
      end
    end
  end
end
