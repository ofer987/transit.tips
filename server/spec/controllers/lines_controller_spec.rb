require 'rails_helper'

RSpec.describe LinesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let!(:statuses) do
      create_list(:status, 2, line_id: 4)
    end

    context 'searching for existing lines' do
      it 'returns related statuses' do
        get :show, { id: 4 }

        actual = JSON.parse(response.body)

        expect(actual).to have_key('statuses')
        expect(actual['statuses'].count).to eq(2)
      end

      it "returns http success" do
        get :show, { id: 4 }

        expect(response).to have_http_status(:success)
      end
    end

    context 'searching for non-existent line' do
      it 'returns 404' do
        get :show, { id: 5 }

        expect(response).to have_http_status(404)
      end
    end
  end

end
