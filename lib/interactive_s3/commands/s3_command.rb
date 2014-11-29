module InteractiveS3::Commands
  class S3Command < Base
    S3_PATH_PREFIX = /^s3:\/\//
    LOCAL_PATH_PREFIX = /^:/
    OPTION_PREFIX = /^--/
    HELP_SUB_COMMAND = /^help$/
    TARGET_SUB_COMMANDS = %w(mv rb rm).freeze

    def initialize(context, name, arguments = [])
      super
      parse_arguments
    end

    def execute
      pid = Process.spawn(
        *command_with_arguments,
        out: $stdout,
        err: $stderr
      )
      wait_for_process(pid)
      $? && $?.success?
    rescue SystemCallError => e
      puts e.message
      false
    ensure
      if reset_target?
        s3.reset unless s3.exists?
      end
    end

    private

    alias sub_command name

    def parse_arguments
      arguments.map! {|argument|
        case argument
        when S3_PATH_PREFIX, HELP_SUB_COMMAND, OPTION_PREFIX
          argument
        when LOCAL_PATH_PREFIX
          argument.sub(LOCAL_PATH_PREFIX, '')
        else
          stack = InteractiveS3::S3Path.new(argument, s3.stack).resolve
          "s3://#{stack.join('/')}"
        end
      }
    end

    def command_with_arguments
      arguments << "#{s3.current_path}/" if list_command_with_no_s3_path?
      ['aws', 's3', sub_command, arguments].flatten
    end

    def list_command_with_no_s3_path?
      list_command? && !help_sub_command? && !include_s3_path?
    end

    def list_command?
      sub_command == 'ls'
    end

    def help_sub_command?
      arguments.include?('help')
    end

    def include_s3_path?
      arguments.any? {|argument| argument.match(S3_PATH_PREFIX) }
    end

    def reset_target?
      TARGET_SUB_COMMANDS.include?(sub_command)
    end

    def wait_for_process(pid)
      Process.wait(pid)
    rescue Interrupt
      Process.kill('INT', pid)
      retry
    end
  end
end
