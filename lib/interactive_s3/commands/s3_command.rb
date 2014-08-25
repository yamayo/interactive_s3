module InteractiveS3::Commands
  class S3Command < Base
    S3_PATH_PREFIX = /^s3:\/\//

    LOCAL_PATH_PREFIX = /^:/

    OPTION_PREFIX = /^--/

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
      if target_sub_command? && !s3.exist?
        s3.reset
      end
    end

    private

    alias sub_command name

    def parse_arguments
      arguments[range].map! do |argument|
        case argument
        when S3_PATH_PREFIX
          next
        when LOCAL_PATH_PREFIX
          argument.sub!(LOCAL_PATH_PREFIX, '')
        when OPTION_PREFIX
          break
        else
          argument.sub!('.', '') if argument == '.' # TODO: 代入だと上手くいかない
          argument.insert(0, "#{s3.current_path}/")
        end
      end

      if list_command? && !s3_path_exist?
        arguments << s3.current_path
      end
    end

    def range
      if arguments.first =~ OPTION_PREFIX
        argument_size-2..argument_size-1
      else
        0..1
      end
    end

    def argument_size
      arguments.size
    end

    def command_with_arguments
      puts "arguments: #{arguments}"
      ['aws', 's3', sub_command, arguments].flatten
    end

    def list_command?
      sub_command == 'ls'
    end

    def s3_path_exist?
      arguments.any? {|argument| argument.match(S3_PATH_PREFIX) }
    end

    def target_sub_command?
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
