require 'rails_helper'

RSpec.describe Poller::Tweet do
  context '#fetch' do
    let(:account) { '@ttcnotices' }

    subject { described_class.new(account) }

    context 'last_id is provided' do
      let(:last_id) { 704687378082959360 }

      it 'returns new statuses after last_id' do
        expect(subject.fetch(last_id)).to_not be_empty
      end
    end

    context 'last_id is not valid' do
      let(:last_id) { -123432 }

      it 'returns 0 statuses' do
        expect(subject.fetch(last_id)).to be_empty
      end
    end

    context 'last_id is not provided' do
      it 'returns last 200 statuses' do
        expect(subject.fetch.count).to eq(200)
      end
    end
  end
end
