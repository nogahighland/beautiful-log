# frozen_string_literal: true
require 'colorize'

module Beautiful
  module Log
    module CodeRandeExtractable
      private

      def numbered_code_lines(backtrace_line)
        file_path, line_number = backtrace_line.split(':')[0..1]
        min_index, max_index = extract_range(line_number.to_i)
        code_lines = code_lines(file_path, min_index, max_index)
        prepend_number_to_code_lines(code_lines, line_number.to_i, min_index + 1)
      end

      # TODO: const
      def extract_range(line_number)
        min_index = line_number - 1 - 3
        min_index = 0 if min_index.negative?
        max_index = line_number - 1 + 3
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

      # TODO: color - code_lines
      def prepend_number_to_code_lines(code_lines, line_number, min_line_number)
        line_numbers = line_numbers(min_line_number, code_lines.length)
        line_code_pairs = [line_numbers, code_lines].transpose
        line_code_pairs.map do |line_code_pair|
          number, code = line_code_pair
          code = number == line_number ? code.bold.underline : code
          "\t  #{number}: #{code}".cyan
        end.join("\n")
      end

      def line_numbers(min_line_number, code_line_length)
        (min_line_number..min_line_number + code_line_length - 1).to_a
      end
    end
  end
end
