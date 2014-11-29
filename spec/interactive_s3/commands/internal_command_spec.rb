require 'spec_helper'

describe InteractiveS3::Commands::InternalCommand do
  let(:context) { double('context') }
  let(:s3) { InteractiveS3::S3.new }
  let(:state) { {} }

  before do
    allow(context).to receive(:s3).and_return(s3)
    allow(context).to receive(:state).and_return(state)
  end

  describe '.fetch' do
    subject { described_class.fetch(name.to_sym, InteractiveS3::Commands::S3Command) }

    context 'given the params `cd`' do
      let(:name) { 'cd' }

      it { is_expected.to be described_class::Chdir }
    end

    context 'given the params `pwd`' do
      let(:name) { 'pwd' }

      it { is_expected.to be described_class::Pwd }
    end

    context 'given the params `lls`' do
      let(:name) { 'lls' }

      it { is_expected.to be described_class::LocalList }
    end

    context 'given the params `exit`' do
      let(:name) { 'exit' }

      it { is_expected.to be described_class::Exit }
    end

    context 'given the params `ls`' do
      let(:name) { 'ls' }

      it { is_expected.to be InteractiveS3::Commands::S3Command }
    end
  end

  describe described_class::Chdir do
    describe '#execute' do
      before do
        allow(s3).to receive(:exists?).and_return(true)
        s3.stack << 'mybucket' << 'foo' << 'bar'
      end

      let(:command) { described_class.new(context, 'cd', arguments) }

      context 'target is nil' do
        let(:arguments) { [] }

        before { command.execute }

        it { expect(s3.stack).to be_empty }
        it { expect(state[:previous_stack]).to eq %w(mybucket foo bar) }
      end

      context 'target is `-`' do
        let(:arguments) { ['-'] }

        before do
          state[:previous_stack] = %w(xxx yyy)
          command.execute
        end

        it { expect(s3.stack).to eq %w(xxx yyy) }
        it { expect(state[:previous_stack]).to eq %w(mybucket foo bar) }
      end

      context 'target is `xxx/yyy`' do
        let(:arguments) { ['xxx', 'yyy'] }

        before do
          allow_any_instance_of(InteractiveS3::S3Path).to receive(:resolve).and_return(['foo'])
          command.execute
        end

        it { expect(s3.stack).to eq %w(foo) }
        it { expect(state[:previous_stack]).to eq %w(mybucket foo bar) }
      end
    end
  end

  describe described_class::LocalList do
    describe '#execute' do
      let(:command) { described_class.new(context, 'lls') }

      before do
        allow(Dir).to receive(:entries).with('.').and_return(['.', '..', 'foo', 'bar'])
      end

      it { expect { command.execute }.to output("foo\nbar\n").to_stdout }
    end
  end

  describe described_class::Pwd do
    describe '#execute' do
      let(:command) { described_class.new(context, 'pwd') }

      context 'when the s3 path is root' do
        before do
          allow(s3).to receive(:root?).and_return(true)
        end

        it { expect { command.execute }.to output("/\n").to_stdout }
      end

      context 'when the s3 path isn\'t root' do
        before do
          allow(s3).to receive(:root?).and_return(false)
          allow(s3).to receive(:current_path).and_return("s3://mybucket/foo/bar")
        end

        it { expect { command.execute }.to output("s3://mybucket/foo/bar\n").to_stdout }
      end
    end
  end

  describe described_class::Exit do
    describe '#execute' do
      let(:command) { described_class.new(context, 'exit') }

      it { expect { command.execute }.to raise_exception(SystemExit) }
    end
  end
end
