require 'spec_helper'

describe InteractiveS3::Interpreter do
  let(:interpreter) { described_class.new }
  let(:input) { double('input') }

  describe '#execute' do
    before do
      allow(interpreter).to receive(:puts)
    end

    it 'build command and execute it' do
      expect(interpreter.execute('pwd')).to be_nil
    end

    it 'handles parse errors' do
      expect(interpreter).to receive(:build_command).with(input).and_raise(InteractiveS3::CommandError)
      expect(interpreter.execute(input)).to be_nil
    end
  end
end
