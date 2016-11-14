require 'rails_helper'

RSpec.describe Report::Analyser, type: :model do
  good_descriptions = [
    'Line 1 running well',
    '',
    'ALL CLEAR: The delay at King and Jefferson has cleared. 504 King and 514 Cherry have resumed regular routing. #TTC',
  ]

  bad_descriptions = [
    '514 Cherry changing direction due to a stalled streetcar at King and Jefferson. #TTC',
    '514 Cherry turning back eastbound via Shaw, Queen, Dufferin, due to a stalled streetcar at King and Jefferson. #TTC',
    'REMINDER: Service suspended on Line 1 between St George and Lawrence West due to scheduled signal upgrades. Shuttle… https://t.co/5XngerI9Dy',
    '106 York University diverting northbound via Four Winds, Columbia, Murray Ross, due to auto\'s in collision at Sentinel and Murray Ross. #TTC',
    '504 King and 514 Cherry holding westbound at King and Jefferson #TTC',
    '25 Don Mills and 185 Don Mills Rocket are delayed 25 minutes due to construction at Don Mills and Eglinton. #TTC',
    'Toronto Police Investigation on board the 510 streetcar. #TTC'
  ]

  context 'good descriptions' do
    good_descriptions.each do |desc|
      context desc do
        it 'returns true' do
          condition = subject.smooth_road?(desc)

          expect(condition).to eq(true)
        end
      end
    end
  end

  context 'bad descriptions' do
    bad_descriptions.each do |desc|
      context desc do
        it 'returns false' do
          condition = subject.smooth_road?(desc)

          expect(condition).to eq(false)
        end
      end
    end
  end
end
