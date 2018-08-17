require 'rails_helper'

# require_relative '../../app/models/ttc/closure.rb'

describe Poller::TtcClosures do
  let(:calendar) { nil }
  subject(:poller) { described_class.new(calendar, Time.zone.now) }

  context '#get_current' do
    skip
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
    skip
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
          FactoryGirl.build(:invalid_closure),
          # valid record
          FactoryGirl.build(:lawrence_to_st_clair)
        ]

        expect { poller.save_current }
          .to change { Ttc::Closure.count }
          .by(1)
      end
    end
  end

  context '#publish' do
    let(:closures) do
      [
        FactoryGirl.create(:finch_to_sheppard_closure),
        FactoryGirl.create(:lawrence_to_st_clair)
      ]
    end
    let(:calendar) { FactoryGirl.create(:fake_calendar, name: 'TTCC') }
    let(:fake_service) { double }
    let(:insert_event_result) { double }

    before :each do
      allow(subject)
        .to receive(:service)
        .and_return(fake_service)

      allow(fake_service)
        .to receive(:insert_event)
        .and_return(insert_event_result)

      allow(insert_event_result)
        .to receive(:id)
        .and_return(SecureRandom.uuid)
    end

    it 'saves an event model to the database' do
      expect { subject.publish(closures.first) }
        .to change { Event.count }
        .by(1)
    end
  end

  context '#delete_cancelled_closures' do
    let(:calendar) { FactoryGirl.create(:fake_calendar) }
    let(:past_closures) do
      results = []
      closure = FactoryGirl.create(:finch_to_sheppard_closure, start_at: Time.zone.now - 1.year, end_at: Time.zone.now - 1.year + 1.day)
      FactoryGirl.create(:event, id: 0, ttc_closure_id: closure.id, calendar: calendar)
      results << closure

      closure = FactoryGirl.create(:finch_to_sheppard_closure, start_at: Time.zone.now - 1.year + 2.days, end_at: Time.zone.now - 1.year + 4.day)
      FactoryGirl.create(:event, id: 1, ttc_closure_id: closure.id, calendar: calendar)
      results << closure

      results
    end

    let(:future_closures) do
      results = []
      closure = FactoryGirl.create(:finch_to_sheppard_closure, start_at: Time.zone.now + 1.day, end_at: Time.zone.now + 2.day)
      FactoryGirl.create(:event, id: 2, ttc_closure_id: closure.id, calendar: calendar)
      results << closure

      closure = FactoryGirl.create(:finch_to_sheppard_closure, start_at: Time.zone.now + 2.days, end_at: Time.zone.now + 4.day)
      FactoryGirl.create(:event, id: 3, ttc_closure_id: closure.id, calendar: calendar)
      results << closure

      results
    end

    before :each do
      past_closures
      future_closures
    end

    let(:closures) do
      [
        FactoryGirl.create(:finch_to_sheppard_closure),
        FactoryGirl.create(:lawrence_to_st_clair)
      ]
    end
    let(:calendar) { FactoryGirl.create(:fake_calendar, name: 'TTCC') }
    let(:fake_service) { double }
    let(:insert_event_result) { double }

    before :each do
      allow(subject)
        .to receive(:service)
        .and_return(fake_service)

      allow(fake_service)
        .to receive(:delete_event)
        .and_return(nil)

      allow(insert_event_result)
        .to receive(:id)
        .and_return(SecureRandom.uuid)
    end

    context 'has the same current closures' do
      let(:new_future_closures) { future_closures }

      it 'does not delete records from the ttc_closures table' do
        expect { subject.delete_cancelled_closures(new_future_closures) }
          .to_not change { Event.count }
      end
    end

    context 'has only one same closure' do
      let(:new_future_closures) { future_closures[0..0] }

      it 'deletes one record from the ttc_closures table' do
        expect { subject.delete_cancelled_closures(new_future_closures) }
          .to change { Event.count }
          .by(-1)
      end
    end

    context 'has no closures' do
      let(:new_future_closures) { [] }

      it 'deletes all records the ttc_closures table' do
        expect { subject.delete_cancelled_closures(new_future_closures) }
          .to change { Event.count }
          .by(-2)
      end
    end

    context 'has one new closure and one same closure' do
      let(:new_future_closures) do
        results = []

        results << future_closures[0]

        closure = FactoryGirl.create(:finch_to_sheppard_closure, start_at: Time.zone.now + 10.days, end_at: Time.zone.now + 11.day)
        FactoryGirl.create(:event, id: 4, ttc_closure_id: closure.id, calendar: calendar)
        results << closure

        results
      end

      it 'does not delete records from the ttc_closures table' do
        expect { subject.delete_cancelled_closures(new_future_closures) }
          .to_not change { Event.count }
      end

      # verify that one record was deleted
      it 'deletes the cancelled future closure' do
        subject.delete_cancelled_closures(new_future_closures)

        expect { future_closures[1].reload }
          .to raise_exception(ActiveRecord::RecordNotFound)
      end

      it "deletes the cancelled closure's associated event" do
        subject.delete_cancelled_closures(new_future_closures)

        expect(Event.where(ttc_closure_id: future_closures[1].id).first)
          .to be_nil
      end

      # verify that one same record exists
      it 'did not delete the valid future closure' do
        subject.delete_cancelled_closures(new_future_closures)

        expect { future_closures[0].reload }
          .to_not raise_exception
      end

      it "did not delete the valid closure's associated event" do
        subject.delete_cancelled_closures(new_future_closures)

        expect(Event.where(ttc_closure_id: future_closures[0].id).first)
          .to_not be_nil
      end
    end
  end
end
