module InteractiveS3
  class CommandBuilder
    def initialize(context, params)
      @context = context
      @name, *@arguments = params.split(/\s/)
    end

    def build
      command_class.new(context, name, arguments)
    end

    private

    attr_reader :context, :name, :arguments

    def command_class
      Commands::InternalCommand.fetch(name.to_sym, Commands::S3Command)
    end
  end
end
