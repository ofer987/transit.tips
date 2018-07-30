require 'rails_helper'

# require_relative '../../app/models/ttc/closure.rb'

describe Poller::TtcClosures do
  subject { described_class.new }

  context '#get_current' do
    it 'has closures' do
      expect(subject.get_current.any?).to be true
    end

    context 'first item' do
      subject { described_class.new.get_current[0] }

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
end
