require 'rails_helper'

describe Endpoints do
  subject { described_class.new(latitude, longitude) }

  context 'for [43.78561654917611, -79.44631293538535]' do
    let(:latitude) { 43.78561654917611 }
    let(:longitude) { -79.44631293538535 }

    context '#nearby_locations' do
      it 'returns back a JSON object' do
        expect(subject.nearby_locations).to be_a Hash
      end

      it 'has the longitude' do
        expect(subject.nearby_locations).to have_key(:longitude)
        expect(subject.nearby_locations[:longitude]).to eq(-79.44631293538535)
      end

      it 'has the latitude' do
        expect(subject.nearby_locations).to have_key(:latitude)
        expect(subject.nearby_locations[:latitude]).to eq(43.78561654917611)
      end

      it 'returns the schedule' do
        expect(subject.nearby_locations).to have_key(:schedule)
      end
    end

    context '#address' do
      it 'returns an address' do
        expect(subject.address).to eq('1 Rockford Rd, North York, ON M2R 1Z2, Canada')
      end
    end
  end

  context 'for [43.736610, -79.411776]' do
    let(:latitude) { 43.736610 }
    let(:longitude) { -79.411776 }

    context '#address' do
      it 'returns an address' do
        expect(subject.address).to eq('85 Joicey Blvd, North York, ON M5M 2T4, Canada')
      end
    end
  end
end
