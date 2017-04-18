# frozen_string_literal: true
require 'pp'
require 'beautiful/log/modules'
require "awesome_print"

module Beautiful
  module Log
    class Formatter < ::Logger::Formatter
      attr_reader :only_project_code, :ignore_paths, :allow_path, :backtrace_ignore_paths,
                  :highlighted_line_range, :highlighted_line_styles, :backtrace_styles,
                  :error_file_path_styles, :status_code_styles, :severity_styles

      cattr_accessor(:datetime_format) { '%Y-%m-%d %H:%M:%S' }

      include Modules::CodeRangeExtractable, Modules::PathOmmittable,
              Modules::ErrorFormattable, Modules::RenderLogFoematter,
              Modules::CompleteLogFormatter, Modules::Stylable

      DEFAULT_STATUS_CODE_STYLES = { (1..3) => [:green, :bold], 'other' => [:red, :bold] }.freeze
      DEFAULT_SEVERITY_STYLES = { FATAL: [:red, :swap], ERROR: :red, WARN: :light_red }.freeze

      # rubocop: disable Metrics/AbcSize, Style/ParameterLists, Style/MethodLength
      def initialize(
        only_project_code: true,
        shrink_bundle_path: true,
        backtrace_ignore_paths: [],
        highlighted_line_range: 3,
        highlighted_line_styles: :cyan,
        backtrace_styles: :light_red,
        error_file_path_styles: :red,
        status_code_styles: {},
        severity_styles: {},
        occurence_line: :light_blue
      )
        @only_project_code = only_project_code
        @shrink_bundle_path = shrink_bundle_path
        @ignore_paths = backtrace_ignore_paths.map do |path|
          Regexp.new "#{Rails.root}/#{path}"
        end << Regexp.new(bundle_path)
        @allow_path = Regexp.new bundle_install_path
        @backtrace_ignore_paths = backtrace_ignore_paths
        @highlighted_line_range = highlighted_line_range
        @highlighted_line_styles = highlighted_line_styles
        @backtrace_styles = backtrace_styles
        @error_file_path_styles = error_file_path_styles
        @status_code_styles = DEFAULT_STATUS_CODE_STYLES.merge(status_code_styles).with_indifferent_access
        @severity_styles = DEFAULT_SEVERITY_STYLES.merge(severity_styles).with_indifferent_access
        @occurence_line = occurence_line
      end

      def call(severity, timestamp, _progname, message)
        problem_code = highlighted_code(message) if message.is_a?(Exception)
        header = message_header(timestamp, severity, caller)
        message = "#{header} -- : #{message_body(message, header.uncolorize.length + 6)}\n"
        message = "#{message}\n#{problem_code}" if problem_code.present?
        message = "\n#{message}\n" if %w(FATAL ERROR).include?(severity)
        message
      end

      private

      def message_header(timestamp, severity, backtrace)
        header = "[#{timestamp.strftime(datetime_format)}] (pida=#{$PROCESS_ID}) #{file_line(backtrace)} #{format('%5s', severity)}"
        colored_header(severity, header)
      end

      def file_line(backtrace_lines)
        file_line = backtrace_lines.find do |line|
          (only_project_code && project_code?(line)) && !ignore_path?(line)
        end
        file_line&.sub!(bundle_install_path, '') if @shrink_bundle_path
        apply_styles(omit_project_path(file_line), @occurence_line) if file_line.present?
      end

      def colored_header(severity, header)
        styles = severity_styles[severity.to_sym]
        return header if styles.blank?
        apply_styles(header, styles)
      end

      def message_body(message, header_length)
        return format_exception(message) if message.is_a?(Exception)
        return format_render_log(message) if render_log?(message)
        return format_complete_log(message) if complete_log?(message)
        return message if message.is_a?(String)
        message.ai.gsub(/\n/, "\n" + ' ' * header_length)
      end

      def highlighted_code(error)
        problem_point = error.backtrace.find { |backtrace_line| !ignore_path?(backtrace_line) }
        return unless problem_point.present?
        file_path = apply_styles(problem_point.split(':')[0], error_file_path_styles)
        "\t#{file_path}\n#{numbered_code_lines(problem_point)}\n"
      end
    end
  end
end
