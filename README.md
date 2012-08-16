# Tilt::Jadeite

Render Jade templates with help from therubyracer embedded V8 JavaScript interpreter.

Also adds Jade support to Sinatra, i.e.:

```ruby
get "/freakin" do
  jade 'p this is soo #{adjective.substring(0,5) + "in awesome"}', :locals => { :adjective => "freaky" }
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'tilt-jadeite'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tilt-jadeite

## Usage

### Sinatra

#### hello.jade

```jade
p Hello #{what}!
```

#### hello_world.rb

```ruby
require "tilt-jadeite/sinatra"

class HelloWorld < Sinatra::Base
  helpers Sinatra::Jade

  get "/hello" do
    jade :hello, :what => "world"
  end
end

```

Accessing your app at /hello will output `<p>Hello world!</p>`

## Author

Bjørge Næss <bjoerge@bengler.no>

## LICENSE

MIT