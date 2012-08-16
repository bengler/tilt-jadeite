module Sinatra
  module Jade
    def jade(*args)
      render(:jade, *args)
    end
  end
  helpers Jade
end