require 'spec_helper'

describe InteractiveS3::Commands::Base do
  let(:context) { double('context') }
  let(:name) { double('name') }
  let(:arguments) { [] }

  before do
    allow(context).to receive(:s3)
    allow(context).to receive(:state)
  end

  describe '#execute' do
    context 'when implement the method' do
      let(:instance) do
        Class.new(described_class) {
          def execute; end
        }.new(context, name)
      end

      it { expect(instance.execute).to be_nil }
    end

    context 'when does not implement the method' do
      let(:instance) do
        Class.new(described_class).new(context, name)
      end

      it { expect { instance.execute }.to raise_error(NotImplementedError) }
    end
  end
end
