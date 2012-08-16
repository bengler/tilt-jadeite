# Tilt extension for jade

require "tilt-jadeite/version"
require 'jadeite/environment'
require 'tilt'

module Tilt
  module Jadeite
    class JadeTemplate < Template
      self.default_mime_type = "text/html"

      def initialize_engine
        return if defined? ::Jadeite
        require_template_library 'jade'
      end

      def prepare
        env = ::Jadeite::Environment.new
        @compiled = env.compile(data, :filename => eval_file)
      end

      def evaluate(scope, locals, &block)
        @compiled.render(locals.merge(scope.is_a?(Hash) ? scope : {}))
      end
    end
  end
  register Jadeite::JadeTemplate, 'jade'
end
