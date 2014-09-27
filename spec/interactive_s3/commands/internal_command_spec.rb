require 'spec_helper'

describe InteractiveS3::Commands::InternalCommand do
  # let(:cli) { described_class.new }
  let(:context) { instance_double('Context') }

  before do
    allow(context).to receive(:s3)
    allow(context).to receive(:state)
  end

  describe '.fetch' do
    context ':cd' do
      it do
        command = described_class.fetch(:cd)
        expect(command).to be described_class::Chdir
      end
    end
  end

  describe described_class::Chdir do
    describe '#execute' do
      before do
      end
      xit do
        command = described_class.new(context, 'cd')
        expect(command.execute).to be_nil
      end
    end
  end

  describe described_class::Pwd do
    describe '#execute' do
      xit do
        command = described_class.new(context, 'pwd')
        expect(command.execute).to be_nil
      end
    end
  end

  describe described_class::Exit do
    describe '#execute' do
      let(:command) { described_class.new(context, 'exit') }

      xit do
        expect { command.execute }.to raise_exception(SystemExit)
      end
    end
  end
end
