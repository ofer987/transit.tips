require 'rails_helper'

RSpec.describe Status, type: :model do
  describe '.bulk_insert!' do
    context 'all statuses are valid' do
      let(:statuses) do
        [
          {
            tweet_id: 12343432,
            line_id: 87,
            line_type: 'Bus',
            description: '87 Cosburn route bypassing East York Acres stop, until the end of service, due to inclement road conditions. #TTC',
            tweeted_at: DateTime.new(2016, 3, 2, 0, 41, 19, 0)
          },
          {
            tweet_id: 12343433,
            line_id: 509,
            line_type: 'Streetcar',
            description: 'ALL CLEAR: The delay due to power issues have cleared. 509 Harbourfront & 510 Spadina have returned to regular routing. #TTC',
            tweeted_at: DateTime.new(2016, 3, 1, 23, 41, 19, 0)
          }
        ]
      end

      it 'saves the statuses' do
        expect { described_class.bulk_insert!(statuses) }
          .to change { described_class.count }.by(2)
      end
    end

    context 'one of the statuses is invalid' do
      let(:statuses) do
        [
          {
            tweet_id: 12343432,
            line_id: nil,
            line_type: 'Bus',
            description: '87 Cosburn route bypassing East York Acres stop, until the end of service, due to inclement road conditions. #TTC',
            tweeted_at: DateTime.new(2016, 3, 2, 0, 41, 19, 0)
          },
          {
            tweet_id: 12343433,
            line_id: 509,
            line_type: 'Streetcar',
            description: 'ALL CLEAR: The delay due to power issues have cleared. 509 Harbourfront & 510 Spadina have returned to regular routing. #TTC',
            tweeted_at: DateTime.new(2016, 3, 1, 23, 41, 19, 0)
          }
        ]
      end

      it 'saves the valid statuses' do
        expect { described_class.bulk_insert!(statuses) }
          .to change { described_class.count }.by(1)
      end
    end
  end

  describe '.last_status' do
    context 'there are statuses in the database' do
      let!(:statuses) do
        create_list(:status, 10)
      end

      it 'returns the last status' do
        expect(described_class.last_status.id).to eq(statuses.last.id)
      end
    end

    context 'there are no statuses in the database' do
      it 'returns the a null status object' do
        expect(described_class.last_status).to be_a Nil::Status
      end
    end
  end

  describe 'Statuses are indexed on tweet_id and line_id' do
    let(:statuses) do
      [
        {
          tweet_id: 12343432,
          line_id: 45,
          line_type: 'Bus',
          description: 'Problems affecting 301, the 45, and 504. Sorry',
          tweeted_at: DateTime.new(2015, 3, 2, 0, 41, 19, 0)
        },
        {
          tweet_id: 12343432,
          line_id: 504,
          line_type: 'Streetcar',
          description: 'Problems affecting 301, the 45, and 504. Sorry',
          tweeted_at: DateTime.new(2015, 3, 2, 0, 41, 19, 0)
        }
      ]
    end

    it 'saves both statuses' do
      expect do
        statuses.each do |status|
          Status.create!(status)
        end
      end.to change { Status.count }.by(2)
    end
  end
end
