require 'rails_helper'

describe Endpoints do
  context '#nearby_locations' do
    let(:longitude) { 43.78561654917611 }
    let(:latitude) { -79.44631293538535 }

    subject { described_class.new(latitude, longitude) }

    it 'returns back a JSON object' do
      expect(subject.nearby_locations).to be_a Hash
    end

    it 'has the longitude' do
      expect(subject.nearby_locations).to have_key(:longitude)
      expect(subject.nearby_locations[:longitude]).to eq(43.78561654917611)
    end

    it 'has the latitude' do
      expect(subject.nearby_locations).to have_key(:latitude)
      expect(subject.nearby_locations[:latitude]).to eq(-79.44631293538535)
    end

    it 'returns the schedule' do
      expect(subject.nearby_locations).to have_key(:schedule)
    end
  end
end
