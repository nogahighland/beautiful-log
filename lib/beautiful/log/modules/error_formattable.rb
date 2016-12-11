# frozen_string_literal: true
require 'colorize'
require 'beautiful/log/modules/stylable'

module Beautiful
  module Log
    module Modules
      module ErrorFormattable
        include Stylable

        private

        def format_exception(e)
          error_message = e.to_s
          error_message = apply_styles(error_message, backtrace_styles)
          "#{error_message}\n#{format_backtrace(e)}"
        end

        def format_backtrace(e)
          lines = e.backtrace
          lines = lines.select do |line|
            (only_project_code && project_code?(line)) && !ignore_path?(line)
          end

          format_lines = lines.map do |line|
            line = highlighted_line(line) if project_code?(line)
            "\t#{line}"
          end
          format_lines.join("\n")
        end

        def highlighted_line(line)
          line = omit_project_path(line)
          file_path, line_number, method = line.split(':')
          levels = file_path.split('/')

          file_path = (levels[0..-2] << levels[-1].bold).join('/')
          line = [file_path, line_number, method].join(':')

          apply_styles(line, backtrace_styles)
        end
      end
    end
  end
end
