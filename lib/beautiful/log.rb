# frozen_string_literal: true
require 'beautiful/log/version'
require 'beautiful/log/formatter'
require 'beautiful/log/task_logging'

module Beautiful
  module Log
    def self.included(klass)
      return unless defined?(Rails) && klass < Rails::Application
      config = klass.config
      Rails.logger = Logger.new(config.paths['log'].first)
      Rails.logger.formatter = Beautiful::Log::Formatter.new
    end
  end
end
