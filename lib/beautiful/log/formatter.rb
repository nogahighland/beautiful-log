require 'colorize'

module Beautiful
  module Log
    class Formatter < ::Logger::Formatter
      attr_reader :only_project_code, :ignore_paths

      def initialize(only_project_code: true, backtrace_ignore_paths: ['vendor/bundle'])
        @only_project_code = only_project_code
        @ignore_paths      = backtrace_ignore_paths.map { |path| Regexp.new "#{Rails.root}/#{path}" }
      end

      cattr_accessor(:datetime_format) { '%Y-%m-%d %H:%m:%S' }

      def call(severity, timestamp, _progname, message)
        "#{message_header(timestamp, severity)} -- : #{message_body(message)}\n"
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
        ignore_paths.find { |path| backtrace_line =~ path } unless ignore_paths.empty?
      end
    end
  end
end
