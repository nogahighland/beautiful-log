# frozen_string_literal: true
require 'beautiful/log/modules/stylable'

module Beautiful
  module Log
    module Modules
      module CompleteLogFormatter
        include Stylable

        private

        COMPLETE_LOG_REGEXP = /\ACompleted (\d{3})/

        def complete_log?(log)
          return false unless log.is_a?(String)
          log =~ COMPLETE_LOG_REGEXP
        end

        def format_complete_log(log)
          status_code_hundread = log.match(COMPLETE_LOG_REGEXP)[1][0].to_i
          _status_range, color = status_code_styles.find do |range, _color|
            next range.include?(status_code_hundread) if range.is_a?(Range)
            range == status_code_hundread if range.is_a?(Integer)
          end
          apply_styles(log, color || status_code_styles[:other]) + "\n"
        end
      end
    end
  end
end
