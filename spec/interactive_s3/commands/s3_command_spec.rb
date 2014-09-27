require 'spec_helper'

describe InteractiveS3::Commands::S3Command do
  let(:s3_command) { described_class.new(context, name, arguments) }
  let(:context) { instance_double('Context', s3: s3, state: {}) }
  let(:name) { double('name') }
  let(:arguments) { ['args'] }
  let(:s3) { double('s3') }

  before do
    allow(Process).to receive(:spawn)
    allow(Process).to receive(:wait)
    allow_any_instance_of(InteractiveS3::S3Path).to receive(:resolve).and_return(['foo', 'bar'])
    allow(s3).to receive(:stack)
  end

  describe '#execute' do
    it { expect(s3_command.execute).to be_truthy }
  end
end
