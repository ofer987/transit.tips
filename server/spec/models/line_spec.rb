require 'rails_helper'

describe Line do
  let!(:statuses) do
    create_list(:status, 2, line_id: 4)
  end

  subject do
    described_class.find_statuses(line_id)
  end

  context 'line_id exists' do
    let(:line_id) { 4 }

    context '#find_statuses' do
      it 'returns the expected statuses' do
        expect(subject).to eq(statuses)
      end

      it 'returns two statuses' do
        expect(subject.count).to eq(2)
      end
    end
  end

  context 'line_id does not exist' do
    let(:line_id) { 8 }

    context '#find_statuses' do
      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end
  end
end
