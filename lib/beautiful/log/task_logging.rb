# frozen_string_literal: true
module Beautiful
  module Log
    module TaskLogging
      def task(*args)
        Rake::Task.define_task(*args) do |task, task_args|
          if block_given?
            Rails.logger&.debug "[#{task.name} #{task.comment}] started"
            begin
              yield(task, task_args)
              Rails.logger&.debug "[#{task.name} #{task.comment}] finished"
            rescue => e
              Rails.logger&.error e
            end
          end
        end
      end
    end
  end
end
extend Beautiful::Log::TaskLogging
