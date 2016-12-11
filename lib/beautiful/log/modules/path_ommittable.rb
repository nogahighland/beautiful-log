# frozen_string_literal: true
module Beautiful
  module Log
    module Modules
      module PathOmmittable
        private

        def omit_project_path(line)
          line.gsub(Rails.root.to_s + '/', '')
        end

        def project_code?(backtrace_line)
          backtrace_line.index(Rails.root.to_s)&.zero?
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
end
