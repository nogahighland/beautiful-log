# frozen_string_literal: true
require 'colorize'

module Beautiful
  module Log
    module ErrorFormattable
      private

      # TODO: color - exception
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

      # TODO: color - filepath
      def highlight_line(line)
        line = omit_project_path(line)
        file_path, line_number, method = line.split(':')
        levels = file_path.split('/')

        file_path = (levels[0..-2] << levels[-1].bold.underline).join('/')
        line = [file_path, line_number, method].join(':')

        line.light_red
      end
    end
  end
end
