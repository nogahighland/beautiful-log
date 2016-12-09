# frozen_string_literal: true
require 'colorize'
require 'beautiful/log/code_range_extractable'
require 'beautiful/log/path_ommittable'
require 'beautiful/log/error_formattable'
require 'beautiful/log/render_log_formatter'
require 'beautiful/log/complete_log_formatter'

module Beautiful
  module Log
    class Formatter < ::Logger::Formatter
      attr_reader :only_project_code, :ignore_paths, :allow_path, :backtrace_ignore_paths, :highlighted_line_range, :highlighted_line_color, :backtrace_color, :error_file_path_color, :status_code_color
      cattr_accessor(:datetime_format) { '%Y-%m-%d %H:%m:%S' }

      include CodeRandeExtractable
      include PathOmmittable
      include ErrorFormattable
      include RenderLogFoematter
      include CompleteLogFormatter

      DEFAULT_STATUS_CODE_COLORS = { (1..3) => :green, 'other' => :red }.freeze

      def initialize(
        only_project_code: true,
        backtrace_ignore_paths: [],
        highlighted_line_range: 3,
        highlighted_line_color: :cyan,
        backtrace_color: :light_red,
        error_file_path_color: :red,
        status_code_color: {}
      )
        @only_project_code = only_project_code
        @ignore_paths = backtrace_ignore_paths.map { |path| Regexp.new "#{Rails.root}/#{path}" } << Regexp.new(bundle_path)
        @allow_path = Regexp.new bundle_install_path
        @backtrace_ignore_paths = backtrace_ignore_paths
        @highlighted_line_range = highlighted_line_range
        @highlighted_line_color = highlighted_line_color
        @backtrace_color = backtrace_color
        @error_file_path_color = error_file_path_color
        @status_code_color = DEFAULT_STATUS_CODE_COLORS.merge(status_code_color)
      end

      def call(severity, timestamp, _progname, message)
        problem_code = highlighted_code(message) if message.is_a?(Exception)
        message = format_render_log(message) if render_log?(message)
        message = format_complete_log(message) if complete_log?(message)
        message = "#{message_header(timestamp, severity)} -- : #{message_body(message)}\n"
        message = "#{message}\n#{problem_code}" if problem_code.present?
        message = "\n#{message}\n" if %w(FATAL ERROR).include?(severity)
        message
      end

      private

      # TODO: color
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
        file_path = problem_point.split(':')[0]
        "\t#{file_path.cyan}\n#{numbered_code_lines(problem_point)}\n"
      end
    end
  end
end
