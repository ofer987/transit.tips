require 'rails_helper'

describe Endpoints do
  context '#nearby_locations' do
    let(:longitude) { 43.78561654917611 }
    let(:latitude) { -79.44631293538535 }

    subject { described_class.new(longitude, latitude) }

    it 'returns back JSON' do
      expect(subject.nearby_locations).to be_a Array
      expect(subject.nearby_locations[0]).to have_key('agency')
    end
  end
end
