require 'spec_helper'

describe InteractiveS3::Commands::S3Command do
  let(:s3_command) { described_class.new(context, name, arguments) }
  let(:context) { double('context') }
  let(:s3) { InteractiveS3::S3.new }
  let(:state) { {} }

  before do
    allow(context).to receive(:s3).and_return(s3)
    allow(context).to receive(:state).and_return(state)
    allow(Process).to receive(:spawn)
    allow(Process).to receive(:wait)
    allow_any_instance_of(InteractiveS3::S3Path).to receive(:resolve).and_return(['mybucket', 'bar'])
  end

  shared_examples_for 'parses commands with arguments and executes it' do |command_with_arguments|
    it do
      expect(Process).to receive(:spawn).with(*command_with_arguments, out: $stdout, err: $stderr)
      expect(s3_command.execute).to be_truthy
    end
  end

  describe '#execute' do
    context 'ls' do
      let(:name) { 'ls' }

      context 'with no sub command' do
        let(:arguments) { [] }

        it_behaves_like 'parses commands with arguments and executes it', ['aws', 's3', 'ls', '/']
      end

      context 'with help sub command' do
        let(:arguments) { ['help'] }

        it_behaves_like 'parses commands with arguments and executes it', ['aws', 's3', 'ls', 'help']
      end
    end

    context 'cp' do
      let(:name) { 'cp' }

      context 'with local path and s3 path and option' do
        let(:arguments) { [':foo', 'bar', '--option'] }

        it_behaves_like 'parses commands with arguments and executes it', ['aws', 's3', 'cp', 'foo', 's3://mybucket/bar', '--option']
      end

      context 'with help sub command' do
        let(:arguments) { ['help'] }

        it_behaves_like 'parses commands with arguments and executes it', ['aws', 's3', 'cp', 'help']
      end
    end
  end
end
