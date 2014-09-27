require 'spec_helper'

describe InteractiveS3::S3 do
  let(:s3) { described_class.new }

  describe '#current_path' do
    context 'when the stack exists' do
      before do
        s3.stack << 'mybucket' << 'foo' << 'bar'
      end

      it { expect(s3.current_path).to eq('s3://mybucket/foo/bar') }
    end

    context 'when the stack does not exists' do
      it { expect(s3.current_path).to be_empty }
    end
  end

  describe '#empty?' do
    context 'when the stack does not exists' do
      it { expect(s3.empty?).to be_truthy }
    end

    context 'when the stack exists' do
      before do
        s3.stack << 'mybucket' << 'foo' << 'bar'
      end

      it { expect(s3.empty?).to be_falsey }
    end
  end

  describe '#reset' do
    before do
      s3.stack << 'mybucket'
      s3.reset
    end

    it { expect(s3.stack).to be_empty }
  end

  describe '#bucket?' do
    context 'when size of the stack is 1' do
      before do
        s3.stack << 'mybucket'
      end

      it { expect(s3.bucket?).to be_truthy }
    end

    context 'when the stack does not exists' do
      it { expect(s3.bucket?).to be_falsey }
    end

    context 'when size of the stack is greater than 1' do
      before do
        s3.stack << 'mybucket' << 'foo'
      end

      it { expect(s3.bucket?).to be_falsey }
    end
  end

  describe '#exist?' do
    context 'when the stack size is empty' do
      it { expect(s3.exist?).to be_truthy }
    end

    context 'when the stack size is not empty' do
      let(:error) { double('error') }
      let(:status) { double('status') }

      before do
        allow(Open3).to receive(:capture3).and_return([output, error, status])
        allow(s3).to receive(:empty?).and_return(false)
      end

      context 'status is success' do
        before do
          allow(status).to receive(:success?).and_return(true)
        end

        it { expect(s3.exist?).to be_truthy }
      end

      context 'status is success and output exists' do
        let(:output) { 'output' }

        before do
          allow(status).to receive(:success?).and_return(true)
        end

        it { expect(s3.exist?).to be_truthy }
      end

      context 'status is success and output exists and current path is bucket' do
        let(:output) { 'output' }

        before do
          allow(status).to receive(:success?).and_return(true)
          allow(s3).to receive(:bucket?).and_return(true)
        end

        it { expect(s3.exist?).to be_truthy }
      end

      context 'status is success and output does not exists' do
        let(:output) { '' }

        before do
          allow(status).to receive(:success?).and_return(true)
          allow(s3).to receive(:bucket?).and_return(false)
        end

        xit { expect(s3.exist?).to be_falsey }
      end

      context 'status failed' do
        let(:output) { 'output' }

        before do
          allow(status).to receive(:success?).and_return(false)
        end

        xit { expect(s3.exist?).to be_falsey }
      end
    end
  end
end
