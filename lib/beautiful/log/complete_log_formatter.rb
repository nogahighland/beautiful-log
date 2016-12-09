# frozen_string_literal: true
module Beautiful
  module Log
    module CompleteLogFormatter
      private

      COMPLETE_LOG_REGEXP = /\ACompleted (\d{3})/

      def complete_log?(log)
        return false unless log.is_a?(String)
        log =~ COMPLETE_LOG_REGEXP
      end

      def format_complete_log(log)
        status_code_hundread = log.match(COMPLETE_LOG_REGEXP)[1][0].to_i
        _status_range, color = status_code_color.find do |range, color|
          next unless range.is_a?(Range)
          range.include?(status_code_hundread)
        end
        log.send(color || status_code_color[:other])
      end
    end
  end
end
