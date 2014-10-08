require 'spec_helper'

describe InteractiveS3::S3Path do
  describe '#resolve' do
    subject { described_class.new(path, stack).resolve }

    let(:stack) { ['foo', 'bar'] }

    context 'with path is `baz`' do
      let(:path) { 'baz' }

      it { is_expected.to eq %w(foo bar baz) }
    end

    context 'with path is `baz/qux`' do
      let(:path) { 'baz/qux' }

      it { is_expected.to eq %w(foo bar baz qux) }
    end

    context 'with path is `../..`' do
      let(:path) { '../..' }

      it { is_expected.to be_empty }
    end

    context 'with path is empty' do
      let(:path) { '' }

      it { is_expected.to be_empty }
    end

    context 'with path is `./baz`' do
      let(:path) { './baz' }

      it { is_expected.to eq %w(foo bar baz) }
    end
  end
end
