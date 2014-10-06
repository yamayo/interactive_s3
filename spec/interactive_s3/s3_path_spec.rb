require 'spec_helper'

describe InteractiveS3::S3Path do
  subject { described_class.new(path, stack) }

  describe '#resolve' do
    let(:stack) { ['foo', 'bar'] }

    context 'with path is baz' do
      let(:path) { 'baz' }

      it { expect(subject.resolve).to eq %w(foo bar baz) }
    end

    context 'with path is baz/qux' do
      let(:path) { 'baz/qux' }

      it { expect(subject.resolve).to eq %w(foo bar baz qux) }
    end

    context 'with path is ../..' do
      let(:path) { '../..' }

      it { expect(subject.resolve).to be_empty }
    end

    context 'with path is empty' do
      let(:path) { '' }

      it { expect(subject.resolve).to be_empty }
    end

    context 'with path is ./baz' do
      let(:path) { './baz' }

      it { expect(subject.resolve).to eq %w(foo bar baz) }
    end
  end
end
