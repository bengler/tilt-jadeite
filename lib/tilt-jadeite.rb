# Tilt extension for jade
module Tilt
  module Jadeite

    require 'tilt-jadeite/version'
    require 'tilt'
    require 'jadeite'

    class JadeTemplate < Template
      self.default_mime_type = "text/html"

      def initialize_engine
        return if defined? ::Jadeite
        require_template_library 'jadeite'
      end

      def environment
        @@environment ||= (@@environment = ::Jadeite::Environment.new(@options))
      end

      def prepare
        @compiled = environment.compile(data, filename: eval_file)
      end

      def evaluate(scope, locals, &block)
        @compiled.render(locals)
      end
    end
  end
  register Jadeite::JadeTemplate, 'jade'
end
