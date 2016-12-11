# frozen_string_literal: true
require 'colorize'

module Beautiful
  module Log
    module Modules
      module Stylable
        private

        def apply_styles(string, styles)
          styles = [styles] if styles.is_a?(Symbol)
          styles.each_with_object(string) do |styled_string, style|
            style = style.to_sym if style.is_a?(String)
            next styled_string.send(style) if ''.respond_to?(style)
            styled_string
          end
        end
      end
    end
  end
end
