require 'colorize'

module Beautiful
  module Log
    class Formatter < ::Logger::Formatter
      attr_reader :only_project_code, :ignore_paths, :allow_path
      cattr_accessor(:datetime_format) { '%Y-%m-%d %H:%m:%S' }

      def initialize(only_project_code: true, backtrace_ignore_paths: [])
        @only_project_code = only_project_code
        @ignore_paths      = backtrace_ignore_paths.map { |path| Regexp.new "#{Rails.root}/#{path}" } << Regexp.new(bundle_path)
        @allow_path        = Regexp.new bundle_install_path
      end

      def call(severity, timestamp, _progname, message)
        problem_code = highlighted_code(message) if message.is_a?(Exception)
        message = "#{message_header(timestamp, severity)} -- : #{message_body(message)}\n"
        message = "#{message}\n#{problem_code}" if problem_code.present?
        message = "\n#{message}\n" if %w(FATAL ERROR).include?(severity)
        message
      end

      private

      def message_header(timestamp, severity)
        header = "[#{timestamp.strftime(datetime_format)}] (pida=#{$PROCESS_ID}) #{format('%5s', severity)}"
        return header.red.swap if 'FATAL' == severity
        return header.red if 'ERROR' == severity
        return header.light_red if 'WARN' == severity
        header
      end

      def message_body(message)
        return format_exception(message) if message.is_a?(Exception)
        return message if message.is_a?(String)
        message.pretty_inspect
      end

      def highlighted_code(error)
        problem_point = error.backtrace.find { |backtrace_line| !ignore_path?(backtrace_line) }
        return unless problem_point.present?
        file_path, line_number, _method = problem_point.split(':')
        line_number = line_number.to_i
        min_index = line_number - 1 - 3
        min_index = 0 if min_index < 0
        max_index = line_number - 1 + 3

        code_lines = []
        open(file_path) do |f|
          file_content = f.read
          code_lines = file_content.split("\n")[min_index..max_index]
        end
        line_code_pairs = [(min_index + 1..min_index + code_lines.length).to_a, code_lines].transpose
        numbered_code = line_code_pairs.map do |line_code_pair|
          code = "\t  #{line_code_pair[0]}: #{line_code_pair[1]}".cyan
          code = code.bold.underline if line_code_pair[0] == line_number
          code
        end.join("\n")

        "\t#{file_path.cyan}\n#{numbered_code}\n"
      end

      def format_exception(e)
        "#{e.to_s.cyan}\n#{format_backtrace(e)}"
      end

      def format_backtrace(e)
        lines = e.backtrace
        lines = lines.select do |line|
          (only_project_code && project_code?(line)) && !ignore_path?(line)
        end

        format_lines = lines.map do |line|
          line = highlight_line(line) if project_code?(line)
          "\t#{line}"
        end
        format_lines.join("\n")
      end

      def highlight_line(line)
        line = omit_project_path(line)
        file_path, line_number, method = line.split(':')
        levels = file_path.split('/')

        file_path = (levels[0..-2] << levels[-1].bold.underline).join('/')
        line = [file_path, line_number, method].join(':')

        line.light_red
      end

      def omit_project_path(line)
        line.gsub(Rails.root.to_s + '/', '')
      end

      def project_code?(backtrace_line)
        backtrace_line.index(Rails.root.to_s).try(:zero?)
      end

      def ignore_path?(backtrace_line)
        return false if backtrace_line =~ allow_path
        ignore_paths.find { |path| backtrace_line =~ path } unless ignore_paths.empty?
      end

      def bundle_install_path
        Bundler.install_path.to_s if defined?(Bundler)
      end

      def bundle_path
        Bundler.bundle_path.to_s if defined?(Bundler)
      end
    end
  end
end
