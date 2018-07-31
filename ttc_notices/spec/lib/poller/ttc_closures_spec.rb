require 'rails_helper'

# require_relative '../../app/models/ttc/closure.rb'

describe Poller::TtcClosures do
  subject(:poller) { described_class.new }

  context '#get_current' do
    subject { poller.get_current }

    it 'has closures' do
      expect(subject.any?).to be true
    end

    it 'has many closures' do
      expect(subject.count).to be > 1
    end

    context 'first item' do
      subject { poller.get_current[0] }

      it 'is a Ttc::Closure' do
        expect(subject).to be_a Ttc::Closure
      end

      its(:line_id) { 1 }
      its(:from_station_name) { 'Finch West' }
      its(:to_station_name) { 'Lawrence West' }
      its(:start_at) { DateTime.new(2018, 07, 29).beginning_of_day }
      its(:end_at) { DateTime.new(2018, 07, 30).end_of_day }
    end
  end

  context '#save_current' do
    it 'writes new records' do
      expect { poller.save_current }
        .to change { Ttc::Closure.count }
        .by_at_least(1)
    end

    it 'returns the amount of sucessfully saved records' do
      count = Ttc::Closure.count
      saved_count = poller.save_current
      new_count = Ttc::Closure.count

      expect(saved_count).to eq(new_count - count)
    end

    context 'one of the records is not valid' do
      it 'saves the other records' do
        allow(poller).to receive(:get_current).and_return [
          # invalid record
          Ttc::Closure.new(
            line_id: 1,
            from_station_name: nil,
            to_station_name: 'Lawrence West',
            start_at: DateTime.new(2018, 07, 29).beginning_of_day,
            end_at: DateTime.new(2018, 07, 30).end_of_day
          ),
          # valid record
          Ttc::Closure.new(
            line_id: 1,
            from_station_name: 'Finch West',
            to_station_name: 'Lawrence West',
            start_at: DateTime.new(2018, 07, 29).beginning_of_day,
            end_at: DateTime.new(2018, 07, 30).end_of_day
          )
        ]

        expect { poller.save_current }
          .to change { Ttc::Closure.count }
          .by_at_least(1)
      end
    end
  end
end
