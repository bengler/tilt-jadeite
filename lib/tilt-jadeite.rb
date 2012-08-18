# Tilt extension for jade

require "tilt-jadeite/version"
require 'jadeite/environment'
require 'tilt'

module Tilt
  module Jadeite

    class << self; attr_accessor :environment end

    class JadeTemplate < Template
      self.default_mime_type = "text/html"

      def initialize_engine
        return if defined? ::Jadeite
        require_template_library 'jade'
      end

      def environment
        Jadeite.environment ||= ::Jadeite::Environment.new
      end

      def prepare
        @compiled ||= environment.compile(data, :filename => eval_file)
      end

      def evaluate(scope, locals, &block)
        @compiled.render(locals)
      end
    end
  end
  register Jadeite::JadeTemplate, 'jade'
end
