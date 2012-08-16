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
        @environment = ::Jadeite::Environment.new
        if @file
          @precompiled = @environment.compile_file(@file)
        end
      end

      def evaluate(scope, locals, &block)
        if @precompiled
          @precompiled.render(locals.merge(scope.is_a?(Hash) ? scope : {}))
        else
          @environment.render(data.to_s, locals.merge(scope.is_a?(Hash) ? scope : {}))
        end
      end
    end
  end
  register Jadeite::JadeTemplate, 'jade'
end
