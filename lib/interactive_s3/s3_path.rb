module InteractiveS3
  class S3Path
    def initialize(target_path, current_stack)
      @target_path = target_path
      @current_stack = current_stack
    end

    def resolve
      scanner = StringScanner.new(target_path.strip)
      stack = current_stack.dup

      begin
        bol = scanner.bol?
        segment = scanner.scan(/[^\/]*/)
        scanner.getch

        case segment.chomp
        when ''
          stack = [] if bol
        when '.'
          next
        when '..'
          stack.pop
        else
          stack << segment
        end
      rescue => e
        raise CommandError.new(e).tap {|ex|
          ex.set_backtrace(e.backtrace)
        }
      end until scanner.eos?

      stack
    end

    private

    attr_reader :current_stack, :target_path
  end
end
