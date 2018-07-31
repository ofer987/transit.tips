require 'rails_helper'

RSpec.describe Ttc::Closure, type: :model do
  before :each do
    described_class.create!(
      line_id: 1,
      from_station_name: 'Finch West',
      to_station_name: 'Lawrence West',
      start_at: DateTime.new(2018, 07, 29).beginning_of_day,
      end_at: DateTime.new(2018, 07, 30).end_of_day
    )
  end

  subject do
    described_class.new(
      line_id: 1,
      from_station_name: from_station_name,
      to_station_name: 'Lawrence West',
      start_at: DateTime.new(2018, 07, 29).beginning_of_day,
      end_at: DateTime.new(2018, 07, 30).end_of_day
    )
  end

  context 'cannot save duplicate records' do
    context 'same case' do
      let(:from_station_name) { 'Finch West' }

      it 'is not valid' do
        expect(subject.valid?).to eq(false)
      end
    end

    context 'different case' do
      let(:from_station_name) { 'FINCH WEST' }

      it 'is not valid' do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  context 'different from_station_name' do
    let(:from_station_name) { 'Sheppard West' }

    it 'is valid' do
      expect(subject.valid?).to eq(true)
    end
  end
end
