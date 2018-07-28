require 'rails_helper'

describe TTC do
  subject { described_class.new }

  context '#get_closures' do
    it 'has closures' do
      expect(subject.get_closures.any?).to be true
    end

    context 'first item' do
      subject { described_class.new.get_closures[0] }

      it 'is for line 1' do
        expect(subject).to eq(1)
      end
    end
  end
end
