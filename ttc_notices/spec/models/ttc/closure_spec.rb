require 'rails_helper'

RSpec.describe Ttc::Closure, type: :model do
  context 'cannot save duplicate records' do
    before :each do
      described_class.create!(
        line_id: 1,
        from_station_name: 'Finch West',
        to_station_name: 'Lawrence West',
        start_at: Time.zone.local(2018, 7, 29).beginning_of_day,
        end_at: Time.zone.local(2018, 7, 30).end_of_day
      )
    end

    subject do
      described_class.new(
        line_id: 1,
        from_station_name: from_station_name,
        to_station_name: 'Lawrence West',
        start_at: Time.zone.local(2018, 7, 29).beginning_of_day,
        end_at: Time.zone.local(2018, 7, 30).end_of_day
      )
    end

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

    subject do
      described_class.new(
        line_id: 1,
        from_station_name: from_station_name,
        to_station_name: 'Lawrence West',
        start_at: Time.zone.local(2018, 7, 29).beginning_of_day,
        end_at: Time.zone.local(2018, 7, 30).end_of_day
      )
    end

    it 'is valid' do
      expect(subject.valid?).to eq(true)
    end
  end

  context '#to_event' do
    subject do
      described_class.new(
        line_id: 1,
        from_station_name: 'Finch West',
        to_station_name: 'Lawrence West',
        start_at: Time.zone.local(2018, 7, 29).beginning_of_day,
        end_at: Time.zone.local(2018, 7, 30).end_of_day
      )
    end

    its(:to_event) { is_expected.to be_a Google::Apis::CalendarV3::Event }
  end

  context "#current" do
    before :each do
      described_class.create!(
        line_id: 1,
        from_station_name: 'Finch West',
        to_station_name: 'Lawrence West',
        start_at: Time.zone.local(2018, 7, 29).beginning_of_day,
        end_at: Time.zone.local(2018, 7, 30).end_of_day
      )
      described_class.create!(
        line_id: 2,
        from_station_name: 'Kennedy',
        to_station_name: 'Ossington',
        start_at: Time.zone.local(2018, 8, 2).beginning_of_day,
        end_at: Time.zone.local(2018, 8, 4).end_of_day
      )
      described_class.create!(
        line_id: 2,
        from_station_name: 'Kennedy',
        to_station_name: 'Ossington',
        start_at: Time.zone.local(2017, 8, 2).beginning_of_day,
        end_at: Time.zone.local(2017, 8, 4).end_of_day
      )
    end

    subject { described_class.current(Time.zone.local(2017, 8, 3)) }

    it 'has two closures' do
      expect(subject.size).to eq(2)
    end

    it 'has closure from Finch West to Lawrence West' do
      expect(subject[0].from_station_name).to eq('Finch West')
      expect(subject[0].to_station_name).to eq('Lawrence West')
    end

    it 'has closure from Kennedy to Ossington' do
      expect(subject[1].from_station_name).to eq('Kennedy')
      expect(subject[1].to_station_name).to eq('Ossington')
    end
  end

  context '#match?' do
    subject do
      described_class.new(
        line_id: 1,
        from_station_name: 'Finch West',
        to_station_name: 'Lawrence West',
        start_at: Time.zone.local(2018, 7, 29).beginning_of_day,
        end_at: Time.zone.local(2018, 7, 30).end_of_day
      )
    end

    context 'Same line, stations, start_at, end_at' do
      let(:other) do
        described_class.new(
          line_id: 1,
          from_station_name: 'Finch West',
          to_station_name: 'Lawrence West',
          start_at: Time.zone.local(2018, 7, 28).beginning_of_day,
          end_at: Time.zone.local(2018, 7, 30).end_of_day
        )
      end

      it 'is not a match' do
        expect(subject.match?(other)).to eq(false)
      end
    end

    context 'Same line, stations, start_at, end_at' do
      let(:other) do
        described_class.new(
          line_id: 1,
          from_station_name: 'Finch West',
          to_station_name: 'Lawrence West',
          start_at: Time.zone.local(2018, 7, 29).beginning_of_day,
          end_at: Time.zone.local(2018, 7, 30).end_of_day
        )
      end

      it 'is a match' do
        expect(subject.match?(other)).to eq(true)
      end
    end
  end
end
