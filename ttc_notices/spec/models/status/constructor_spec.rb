require 'rails_helper'

RSpec.describe Status::Constructor do
  let(:tweets) do
    [
      {
        id: 12343432,
        created_at: 'Wed Mar 02 00:41:19 +0000 2016',
        text: '87 Cosburn route bypassing East York Acres stop, until the end of service, due to inclement road conditions. #TTC'
      },
      {
        id: 12343432,
        created_at: 'Wed Mar 02 01:41:19 +0200 2016',
        text: 'ALL CLEAR: The delay due to power issues have cleared. 509 Harbourfront & 510 Spadina have returned to regular routing. #TTC'
      },
      {
        id: 12343432,
        created_at: 'Wed Mar 02 00:41:19 +0000 2015',
        text: 'ALL CLEAR: The delay due to power issues have cleared. 501 Queen, 504 King, 505 Dundas, routes have returned to regular routing. #TTC'
      },
      {
        id: 12343432,
        created_at: 'Wed Mar 02 00:41:19 +0000 2015',
        text: 'Power issues downtown ongoing on Line 1 (YU). Shuttle buses operating both ways between Bloor and St. Andrew Stns.'
      },
      {
        id: 12343432,
        created_at: 'Wed Mar 02 00:41:19 +0000 2015',
        text: 'Problems affecting 301, the 45, and 504. Sorry'
      }
    ]
  end

  describe '#make' do
    let(:expected_statuses) do
      [
        {
          tweet_id: 12343432,
          line_id: 87,
          type: 'Bus',
          description: '87 Cosburn route bypassing East York Acres stop, until the end of service, due to inclement road conditions. #TTC',
          tweeted_at: DateTime.new(2016, 3, 2, 0, 41, 19, 0)
        },
        {
          tweet_id: 12343432,
          line_id: 509,
          type: 'Streetcar',
          description: 'ALL CLEAR: The delay due to power issues have cleared. 509 Harbourfront & 510 Spadina have returned to regular routing. #TTC',
          tweeted_at: DateTime.new(2016, 3, 1, 23, 41, 19, 0)
        },
        {
          tweet_id: 12343432,
          line_id: 510,
          type: 'Streetcar',
          description: 'ALL CLEAR: The delay due to power issues have cleared. 509 Harbourfront & 510 Spadina have returned to regular routing. #TTC',
          tweeted_at: DateTime.new(2016, 3, 1, 23, 41, 19, 0)
        },
        {
          tweet_id: 12343432,
          line_id: 501,
          type: 'Streetcar',
          description: 'ALL CLEAR: The delay due to power issues have cleared. 501 Queen, 504 King, 505 Dundas, routes have returned to regular routing. #TTC',
          tweeted_at: DateTime.new(2015, 3, 2, 0, 41, 19, 0)
        },
        {
          tweet_id: 12343432,
          line_id: 504,
          type: 'Streetcar',
          description: 'ALL CLEAR: The delay due to power issues have cleared. 501 Queen, 504 King, 505 Dundas, routes have returned to regular routing. #TTC',
          tweeted_at: DateTime.new(2015, 3, 2, 0, 41, 19, 0)
        },
        {
          tweet_id: 12343432,
          line_id: 505,
          type: 'Streetcar',
          description: 'ALL CLEAR: The delay due to power issues have cleared. 501 Queen, 504 King, 505 Dundas, routes have returned to regular routing. #TTC',
          tweeted_at: DateTime.new(2015, 3, 2, 0, 41, 19, 0)
        },
        {
          tweet_id: 12343432,
          line_id: 1,
          type: 'Train',
          description: 'Power issues downtown ongoing on Line 1 (YU). Shuttle buses operating both ways between Bloor and St. Andrew Stns.',
          tweeted_at: DateTime.new(2015, 3, 2, 0, 41, 19, 0)
        },
        {
          tweet_id: 12343432,
          line_id: 301,
          type: 'Streetcar',
          description: 'Problems affecting 301, the 45, and 504. Sorry',
          tweeted_at: DateTime.new(2015, 3, 2, 0, 41, 19, 0)
        },
        {
          tweet_id: 12343432,
          line_id: 45,
          type: 'Bus',
          description: 'Problems affecting 301, the 45, and 504. Sorry',
          tweeted_at: DateTime.new(2015, 3, 2, 0, 41, 19, 0)
        },
        {
          tweet_id: 12343432,
          line_id: 504,
          type: 'Streetcar',
          description: 'Problems affecting 301, the 45, and 504. Sorry',
          tweeted_at: DateTime.new(2015, 3, 2, 0, 41, 19, 0)
        }
      ]
    end

    subject { described_class.new(tweets) }

    it 'returns array of status hashes' do
      expect(subject.build).to eq(expected_statuses)
    end
  end
end
