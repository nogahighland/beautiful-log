# frozen_string_literal: true
require 'colorize'
require 'beautiful/log/modules/stylable'

module Beautiful
  module Log
    module Modules
      module CodeRangeExtractable
        include Stylable

        private

        def numbered_code_lines(backtrace_line)
          file_path, line_number = backtrace_line.split(':')[0..1]
          min_index, max_index = extracted_range(line_number.to_i)
          code_lines = code_lines(file_path, min_index, max_index)
          prepend_number_to_code_lines(code_lines, line_number.to_i, min_index + 1)
        end

        def extracted_range(line_number)
          min_index = line_number - 1 - highlighted_line_range
          min_index = 0 if min_index.negative?
          max_index = line_number - 1 + highlighted_line_range
          [min_index, max_index]
        end

        def code_lines(file_path, min_index, max_index)
          code_lines = []
          open(file_path) do |f|
            file_content = f.read
            code_lines = file_content.split("\n")[min_index..max_index]
          end
          code_lines
        end

        def prepend_number_to_code_lines(code_lines, line_number, min_line_number)
          line_numbers = line_numbers(min_line_number, code_lines.length)
          line_code_pairs = [line_numbers, code_lines].transpose
          max_length = line_number_max_length(line_numbers)
          line_code_pairs.map do |line_code_pair|
            number, code = line_code_pair
            code = number == line_number ? emphasize(code) : code
            number = format_line_number(number, max_length)
            apply_styles("\t  #{number}: #{code}", highlighted_line_styles)
          end.join("\n")
        end

        def emphasize(code)
          match = code.match(/\A(\s*)(\S.+)\z/)
          return code unless match
          match[1] + match[2].bold
        end

        def line_number_max_length(line_numbers)
          Math.log10(line_numbers.max).floor.to_i + 1
        end

        def format_line_number(number, length)
          format("%#{length}d", number)
        end

        def line_numbers(min_line_number, code_line_length)
          (min_line_number..min_line_number + code_line_length - 1).to_a
        end
      end
    end
  end
end
