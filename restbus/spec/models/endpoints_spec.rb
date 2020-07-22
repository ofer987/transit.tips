require 'rails_helper'

describe Endpoints do
  subject { described_class.new(latitude, longitude) }

  context 'for [43.78561654917611, -79.44631293538535]' do
    let(:latitude) { 43.78561654917611 }
    let(:longitude) { -79.44631293538535 }

    context '#routes' do
      it 'returns back a JSON object' do
        expect(subject.routes).to be_an Array
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
        expect(subject.address).to eq('82 Joicey Blvd, North York, ON M5M 2T5, Canada')
      end
    end
  end
end
