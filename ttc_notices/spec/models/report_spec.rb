require 'rails_helper'

RSpec.describe Report, type: :model do
  subject { described_class.new({ statuses: statuses }) }

  context 'no statuses' do
    let!(:statuses) { [] }

    its(:condition) { should eq(:green) }
  end

  context 'for only good statuses' do
    let!(:statuses) do
      create_list(:status, 20, line_id: 1, description: 'ALL CLEAR')
    end

    its(:condition) { should eq(:green) }
  end

  context 'for only bad statuses' do
    let!(:statuses) do
      create_list(:status, 20, line_id: 1, description: '50 changing directions')
    end

    its(:condition) { should eq(:red) }
  end

  context 'for mixed statuses' do
    before do
      create_list(:status, 20, line_id: 1, description: '514 Cherry changing direction due to a stalled streetcar at King and Jefferson. #TTC')
      create_list(:status, 20, line_id: 1, description: 'ALL CLEAR: The delay at King and Jefferson has cleared. 504 King and 514 Cherry have resumed regular routing. #TTC')
    end

    let(:statuses) { Status.where(line_id: 1) }

    its(:condition) { should eq(:red) }
  end
end
