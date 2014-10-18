require 'spec_helper'

describe InteractiveS3::Commands::Base do
  let(:context) { double('context') }
  let(:name) { double('name') }

  before do
    allow(context).to receive(:s3)
    allow(context).to receive(:state)
  end

  describe '#execute' do
    context 'when implements the method' do
      let(:instance) do
        Class.new(described_class) {
          def execute; end
        }.new(context, name)
      end

      it { expect { instance.execute }.not_to raise_error }
    end

    context 'when does not implements the method' do
      let(:instance) do
        described_class.new(context, name)
      end

      it { expect { instance.execute }.to raise_error(NotImplementedError) }
    end
  end
end
