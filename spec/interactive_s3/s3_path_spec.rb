require 'spec_helper'

describe InteractiveS3::S3Path do
  subject { described_class.new(path, stack) }

  describe '#resolve' do
    let(:stack) { ['foo', 'bar'] }

    context 'with stack is hoge' do
      let(:path) { 'hoge' }

      it { expect(subject.resolve).to eq %w(foo bar hoge) }
    end

    context 'with stack is hoge/fuga' do
      let(:path) { 'hoge/fuga' }

      it { expect(subject.resolve).to eq %w(foo bar hoge fuga) }
    end

    context 'with stack is ../..' do
      let(:path) { '../..' }

      it { expect(subject.resolve).to be_empty }
    end

    context 'with stack is empty' do
      let(:path) { '' }

      it { expect(subject.resolve).to be_empty }
    end

    context 'with stack is ./fuga' do
      let(:path) { './fuga' }

      it { expect(subject.resolve).to eq %w(foo bar fuga) }
    end
  end
end
