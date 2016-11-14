require 'rails_helper'

describe Line do
  let!(:statuses) do
    create_list(:status, 2, line_id: 4)
  end

  subject do
    described_class.find(line_id)
  end

  context 'line_id exists' do
    let(:line_id) { 4 }

    context '#find' do
      it 'returns the expected statuses' do
        expect(subject.statuses).to eq(statuses)
      end

      it 'returns two statuses' do
        expect(subject.statuses.count).to eq(2)
      end

      context 'of an ancient history' do
        let!(:statuses) do
          [
            create(:status, line_id: 4, tweeted_at: DateTime.now),
            create(:status, line_id: 4, tweeted_at: DateTime.now.yesterday),
            create(:status, line_id: 4, tweeted_at: DateTime.now.last_week),
            create(:status, line_id: 4, tweeted_at: DateTime.now.last_month + 1.second)
          ]
        end
        let!(:excluded_statuses) do
          [
            create(:status, line_id: 4, tweeted_at: DateTime.now.tomorrow),
            create(:status, line_id: 4, tweeted_at: DateTime.now.last_year),
            create(:status, line_id: 5, tweeted_at: DateTime.now.last_week)
          ]
        end

        subject do
          described_class.find(line_id, { tweeted_by: DateTime.now.last_month })
        end

        it 'returns statuses as far back as one month ago' do
          expect(subject.statuses.to_a).to eq(statuses)
        end
      end

      context 'of a long history' do
        let!(:statuses) do
          create_list(:status, 200, line_id: 4, tweeted_at: DateTime.now)
        end

        subject do
          described_class.find(line_id, { limit: 100 })
        end

        it 'returns 100 statuses' do
          expect(subject.statuses.count).to eq(100)
        end
      end
    end
  end

  context 'line_id does not exist' do
    let(:line_id) { 8 }

    context '#find' do
      it 'returns a nil object' do
        expect(subject).to be_nil
      end
    end
  end
end
