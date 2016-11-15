require 'rails_helper'

RSpec.describe ReportController do
  context 'belongs to lines#show' do
    let(:query) { query_general.merge(query_specific) }

    context '#index' do
      context 'line exists (i.e., has statuses)' do
        let(:status) do
          create(:status,
                 line_id: 1,
                 description: 'ALL CLEAR',
                 tweeted_at: 10.minutes.ago
                )
        end
        let(:line_id) { status.line_id }
        let(:query_general) { { line_id: line_id } }
        let(:query_specific) { {} }

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

      context 'line does not exist' do
        let(:query_general) { { line_id: 23432 } }
        let(:query_specific) { {} }

        it 'returns http status 404' do
          get :index, query

          expect(response).to have_http_status(:not_found)
        end

        it 'returns a json message' do
          get :index, query

          expect(response.content_type).to eq('application/json')
        end

        it 'returns an empty json message' do
          get :index, query

          json = JSON.parse(response.body)
          expect(json).to eq({})
        end
      end
    end
  end
end
