# frozen_string_literal: true
module Beautiful
  module Log
    module RenderLogFoematter
      private

      def format_render_log(backtrace_line)
        formatted_log = omit_project_path(backtrace_line)
        if project_render_view?(backtrace_line)
          formatted_log.send(backtrace_color)
        else
          formatted_log
        end
      end

      def project_render_view?(backtrace_line)
        view_path = view_path(backtrace_line)
        view_path.strip.start_with?('app/view')
      end

      def render_log?(backtrace_line)
        return false unless backtrace_line.is_a?(String)
        backtrace_line.strip.start_with?('Rendered')
      end

      def view_path(backtrace_line)
        backtrace_line.gsub('Rendered ', '')
      end
    end
  end
end
