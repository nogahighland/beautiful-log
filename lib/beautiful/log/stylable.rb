# frozen_string_literal: true
require 'colorize'

module Beautiful
  module Log
    module Stylable
      private

      def apply_styles(string, styles)
        styles = [styles] if styles.is_a?(Symbol)
        styles.each do |style|
          string = string.send(style) if ''.respond_to?(style)
        end
        string
      end
    end
  end
end
