require 'spec_helper'

describe InteractiveS3::CommandBuilder do
  let(:builder) { described_class.new(context, params) }
  let(:context) { double('context') }

  before do
    allow(context).to receive(:s3)
    allow(context).to receive(:state)
  end

  describe '#build' do
    let(:command_class) { double('command_class') }
    let(:params) { 'cd -' }

    before do
      allow(InteractiveS3::Commands::InternalCommand).to receive(:fetch) { command_class }
    end

    it 'creates a command class and initialize it' do
      expect(command_class).to receive(:new).with(context, 'cd', ['-'])
      builder.build
    end
  end
end
