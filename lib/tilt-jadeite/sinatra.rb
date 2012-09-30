module Sinatra
  module Jade
    module Helpers
      def jade(*args)
        render(:jade, *args)
      end
    end
    def self.registered(app)
      app.helpers(Jade::Helpers)
    end
  end
  helpers Jade::Helpers
end