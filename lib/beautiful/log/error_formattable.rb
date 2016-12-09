# frozen_string_literal: true
require 'colorize'

module Beautiful
  module Log
    module ErrorFormattable
      private

      def format_exception(e)
        "#{e.to_s.send(backtrace_color)}\n#{format_backtrace(e)}"
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

        file_path = (levels[0..-2] << levels[-1].bold).join('/')
        line = [file_path, line_number, method].join(':')

        line.send(backtrace_color)
      end
    end
  end
end
