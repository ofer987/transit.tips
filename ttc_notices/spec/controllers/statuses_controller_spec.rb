require 'rails_helper'

RSpec.describe StatusesController, type: :controller do
  let(:from_datetime) { DateTime.new(2015, 1, 1) }

  let(:valid_session) { {} }

  before :all do
    create_list(:status, 150, line_id: 7)
    create_list(:status, 10, line_id: 70)
  end

  describe 'GET #index' do
    it 'returns 100 responses' do
      get :index, { from_datetime: from_datetime }, valid_session

      statuses = JSON.parse(response.body)['data']
      expect(statuses.count).to eq(100)
    end

    context 'from_datetime is not nil' do
      let(:from_datetime) { nil }

      it 'returns the last 100 responses' do
        get :index, { from_datetime: from_datetime }, valid_session

        statuses = JSON.parse(response.body)['data']
        expect(statuses.count).to eq(100)
      end
    end

    context 'from_datetime is not specified' do
      let(:from_datetime) { nil }

      it 'returns the last 100 responses' do
        get :index, {}, valid_session

        statuses = JSON.parse(response.body)['data']
        expect(statuses.count).to eq(100)
      end
    end

    context 'the line_id is specified' do
      it 'only returns relevant stauses ' do
        get :index, { line_id: 70, from_datetime: from_datetime }, valid_session

        json = JSON.parse(response.body)['data']
        line_ids = json.map { |item| item['attributes']['line-id'] }

        expect(line_ids.uniq.count).to eq(1)
        expect(line_ids.uniq.first).to eq(70)
      end
    end
  end
end
