module InteractiveS3
  class History
    HISTORY_SIZE = 500

    def load
      File.read(history_file_path).lines.each do |command|
        Readline::HISTORY << command.chomp
      end
    rescue Errno::ENOENT
    end

    def save
      File.open(history_file_path, 'w') do |file|
        Readline::HISTORY.to_a.last(history_size).each do |command|
          file << "#{command}\n"
        end
      end
    end

    private

    def history_file_exists?
      File.exist?(history_file_path)
    end

    def history_file_path
      "#{Dir.home}/.is3_history"
    end

    def history_size
      HISTORY_SIZE.to_i
    end
  end
end
