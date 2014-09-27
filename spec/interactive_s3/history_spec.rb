require 'spec_helper'
require 'tempfile'

describe InteractiveS3::History do
  let(:history) { described_class.new }
  let(:file) { Tempfile.new('history') }

  before do
    stub_const('Readline::HISTORY', [])
    stub_const('InteractiveS3::History::HISTORY_FILE', file.path)
  end

  after do
    file.delete
  end

  describe '#load' do
    context 'when the file exists' do
      before do
        file.write("pwd\n")
        file.write("ls\n")
        file.rewind
        history.load
      end

      it 'load into the Readline from the file' do
        expect(Readline::HISTORY.to_a).to eq %w(pwd ls)
      end
    end

    context 'when the file is empty' do
      before { history.load }

      it 'does not load into the Readline' do
        expect(Readline::HISTORY.to_a).to be_empty
      end
    end
  end

  describe '#save' do
    context 'when the file exists' do
      before do
        Readline::HISTORY << 'foo'
        history.save
      end

      it 'saves the history from Readline to file' do
        expect(file.each_line.to_a).to eq(['foo'])
      end
    end
  end
end
