# frozen_string_literal: true
module Beautiful
  module Log
    module CompleteLogFormatter
      COMPLETE_LOG_REGEXP = /\ACompleted (\d{3})/

      def complete_log?(log)
        return false unless log.is_a?(String)
        log =~ COMPLETE_LOG_REGEXP
      end

      # color - status_code
      def format_complete_log(log)
        status_code = log.match(COMPLETE_LOG_REGEXP)[1]
        return log.green if status_code =~ /\A(2|3)/
        log.red
      end
    end
  end
end
