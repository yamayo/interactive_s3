module InteractiveS3::Commands
  class Base
    attr_accessor :state, :arguments

    attr_reader :s3, :name

    def initialize(context, name, arguments = [])
      @s3 = context.s3
      @state = context.state
      @name = name
      @arguments = arguments
    end

    def execute
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    private

    def argument_size
      arguments.size
    end
  end
end
