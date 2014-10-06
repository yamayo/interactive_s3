require 'spec_helper'

describe InteractiveS3::Interpreter do
  let(:interpreter) { described_class.new }
  let(:input) { double('input') }
  let(:command) { double('command') }

  describe '#execute' do
    before do
      allow(InteractiveS3::CommandBuilder).to receive_message_chain(:new, :build) { command }
    end

    it 'build the command and executes it' do
      expect(command).to receive(:execute)
      interpreter.execute(input)
    end

    it 'handles parse errors' do
      allow(command).to receive(:execute).and_raise(InteractiveS3::CommandError)
      expect { interpreter.execute(input) }.to output.to_stdout
    end
  end
end
