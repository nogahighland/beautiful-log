module Beautiful
  module Log
    module TaskLogging
      def task(*args)
        Rake::Task.define_task(*args) do |task, task_args|
          if block_given?
            Rails.logger.debug "[#{task.name} #{task.comment}] started" if Rails.logger
            begin
              yield(task, task_args)
              Rails.logger.debug "[#{task.name} #{task.comment}] finished" if Rails.logger
            rescue => e
              Rails.logger.error e if Rails.logger
            end
          end
        end
      end
    end
  end
end
extend Beautiful::Log::TaskLogging
