require 'rails_helper'

describe Html do
  context '.replace_non_breaking_space' do
    subject { Html.replace_non_breaking_space(original) }

    let(:breaking_space) { 160.chr(Encoding::UTF_8) }

    context 'does not have breaking space' do
      let(:original) { ' no _breaking_space    '}

      it 'returns an equivalent string' do
        expect(subject).to eq(' no _breaking_space    ')
      end
    end

    context 'has breaking space' do
      let(:original) { "#{breaking_space} has multiple#{breaking_space} breaking_spaces #{breaking_space}"}

      it 'returns a string without breaking spaces' do
        expect(subject).to eq('  has multiple  breaking_spaces  ')
      end
    end
  end
end
