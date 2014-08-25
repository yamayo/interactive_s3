require 'forwardable'

module InteractiveS3
  class Interpreter
    extend Forwardable

    attr_reader :s3, :state

    def_delegators :s3, :current_path, :root?

    def initialize
      @s3 = S3.new
      @state = Hash.new {|h,k| h[k] = [] }
    end

    def execute(input)
      build_command(input).execute
    end

    private

    def build_command(input)
      CommandBuilder.new(self, input).build
    end
  end
end
