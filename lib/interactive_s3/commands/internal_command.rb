module InteractiveS3::Commands
  module InternalCommand
    def self.fetch(name, default = nil)
      COMMAND_CLASSES.fetch(name, default)
    end

    class Chdir < Base
      def execute
        if target.nil?
          state[:previous_stack] = s3.stack
          s3.reset
          return
        end

        if target.strip == '-'
          s3.stack, state[:previous_stack] = state[:previous_stack], s3.stack
        else
          target.sub!('s3://', '/')
          state[:previous_stack] = s3.stack
          s3.stack = InteractiveS3::S3Path.new(target, s3.stack).resolve
        end
      ensure
        unless s3.exist?
          s3.stack = state[:previous_stack]
        end
      end

      private

      def target
        @target ||= arguments.first
      end
    end

    class LocalList < Base
      def execute
        puts Dir.entries('.')
      end
    end

    class Pwd < Base
      def execute
        puts s3.current_path
      end
    end

    class Exit < Base
      def execute
        exit
      end
    end

    COMMAND_CLASSES = {
      cd: Chdir,
      lls: LocalList,
      pwd: Pwd,
      exit: Exit,
    }.freeze
  end
end
