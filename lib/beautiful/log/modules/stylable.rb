# frozen_string_literal: true
require 'colorized_string'

module Beautiful
  module Log
    module Modules
      module Stylable
        private

        def apply_styles(string, styles)
          string = ColorizedString.new(string)
          styles = [styles] if styles.is_a?(Symbol)
          styles.each do |style|
            style = style.to_sym if style.is_a?(String)
            next unless ''.respond_to?(style)
            string = string.send(style)
          end
          string
        end
      end
    end
  end
end
