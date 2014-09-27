require 'spec_helper'

describe InteractiveS3::CommandBuilder do
  let(:builder) { described_class.new(context, params) }
  let(:context) { double('Context') }

  before do
    allow(context).to receive(:s3)
    allow(context).to receive(:state)
  end

  describe '#build' do
    subject { builder.build }

    context 'given the params `cd`' do
      let(:params) { 'cd' }

      it { is_expected.to be_a InteractiveS3::Commands::InternalCommand::Chdir }
    end

    context 'given the params `pwd`' do
      let(:params) { 'pwd' }

      it { is_expected.to be_a InteractiveS3::Commands::InternalCommand::Pwd }
    end

    context 'given the params `lls`' do
      let(:params) { 'lls' }

      it { is_expected.to be_a InteractiveS3::Commands::InternalCommand::LocalList }
    end

    context 'given the params `exit`' do
      let(:params) { 'exit' }

      it { is_expected.to be_a InteractiveS3::Commands::InternalCommand::Exit }
    end

    context 'given the params `ls`' do
      let(:params) { 'ls' }

      it { is_expected.to be_a InteractiveS3::Commands::S3Command }
    end

    context 'given the params `foo`' do
      let(:params) { 'foo' }

      it { is_expected.to be_a InteractiveS3::Commands::S3Command }
    end
  end
end
