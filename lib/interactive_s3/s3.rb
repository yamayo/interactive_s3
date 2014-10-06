require 'open3'

module InteractiveS3
  class S3
    attr_accessor :stack

    def initialize
      @stack = []
    end

    def current_path
      empty? ? '' : "s3://#{stack.join('/')}"
    end

    def empty?
      stack.empty?
    end
    alias root? empty?

    def reset
      self.stack = []
    end

    def bucket?
      stack.size == 1
    end

    def exist?
      return true if root?
      output, error, status = Open3.capture3('aws', 's3', 'ls', current_path)
      status.success? && (output != '' || (bucket? && output == ''))
    end
  end
end
