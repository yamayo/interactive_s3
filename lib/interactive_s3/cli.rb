require 'readline'

module InteractiveS3
  class CLI
    def start
      history.load
      show_version
      run
    ensure
      history.save
    end

    private

    def run
      while line = readline
        next if line.empty?
        interpreter.execute(line)
      end
      puts "\n"
    rescue Interrupt
      puts "\n"
      retry
    end

    def readline
      if line = Readline.readline(prompt, true)
        Readline::HISTORY.pop if /^\s*$/ =~ line.strip
      end
      line
    end

    def show_version
      puts "InteractiveS3 #{InteractiveS3::VERSION}"
    end

    def prompt
      interpreter.root? ? 's3> ' : "#{interpreter.current_path}> "
    end

    def interpreter
      @interpreter ||= Interpreter.new
    end

    def history
      @history ||= History.new
    end
  end
end
