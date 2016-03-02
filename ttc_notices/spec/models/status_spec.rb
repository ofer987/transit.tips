require 'rails_helper'

RSpec.describe Status, type: :model do
  describe '.bulk_insert' do
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
        expect { described_class.bulk_insert(statuses) }
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
        expect { described_class.bulk_insert(statuses) }
          .to change { described_class.count }.by(1)
      end
    end
  end
end
