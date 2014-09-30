module InteractiveS3
  class History
    HISTORY_FILE = "#{Dir.home}/.is3_history"
    HISTORY_SIZE = 500

    def load
      if file_exist?
        File.read(file_path).each_line do |line|
          Readline::HISTORY << line.chomp
        end
      end
    end

    def save
      File.write(file_path, Readline::HISTORY.to_a.last(history_size).join("\n"))
    end

    private

    def file_exist?
      File.exist?(file_path)
    end

    def file_path
      HISTORY_FILE
    end

    def history_size
      HISTORY_SIZE.to_i
    end
  end
end
