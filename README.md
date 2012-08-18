  ```
         _ _             _           _       _
     _  (_) |  _        (_)         | |     (_)  _
   _| |_ _| |_| |_ _____ _ _____  __| |_____ _ _| |_ _____
  (_   _) | (_   _|_____) (____ |/ _  | ___ | (_   _) ___ |
    | |_| | | | |_      | / ___ ( (_| | ____| | | |_| ____|
     \__)_|\_) \__)    _| \_____|\____|_____)_|  \__)_____)
                      (__/
  ```
  [Tilt](https://github.com/rtomayko/tilt) extension for [Jadeite](https://github.com/bengler/jadeite) that adds support for rendering
  [Jade](http://jade-lang.com) templates from Sinatra with help from
  [The Ruby Racer](https://github.com/cowboyd/therubyracer) embedded V8 JavaScript interpreter.

  ```ruby
  get "/bacon" do
    jade "p Everyone loves #{what[~~(Math.random()*(what.length-1))]} bacon!", :locals => {
      :what => ['smoked', 'tasty', 'delicious', 'chunky']
    }
  end
  ```

  ```
  => <p>Everyone loves chunky bacon!</p>
  ```

  ### Sinatra example

  #### mytemplate.jade

  ```jade
  doctype 5
  html(lang="en")
    head
      title= pageTitle
      script(type='text/javascript')
        if (foo) {
           bar()
        }
    body
      h1 Jade - node template engine
      #container
        if youAreUsingJade
          p You are amazing
        else
          p Get on it!
  ```

  #### app.rb

  ```ruby
  require "tilt-jadeite/sinatra"

  class HelloWorld < Sinatra::Base
    helpers Sinatra::Jade

    get "/jade" do
      jade :mytemplate, :locals => {:pageTitle => "Jade", :youAreUsingJade => true}
    end
  end

  ```

  Accessing your app at /jade will now produce
  ```html
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <title>Jade</title>
      <script type="text/javascript">
        if (foo) {
          bar()
        }
      </script>
    </head>
    <body>
      <h1>Jade - node template engine</h1>
      <div id="container">
        <p>You are amazing</p>
      </div>
    </body>
  </html>
  ```

  ## Rendering server side with Sinatra

  The goal of this library is to be able to use the same templates for rendering on server and in browser. Thus, it makes
  little sense to include support for using Sinatra helper methods in the templates. Therefore, only the `locals` hash are
  passed to the template engine. The keys of this hash will be the only variables/functions exposed to templates.

  If you still wish to expose helper methods from the Sinatra class to your templates,
  you can do this by adding the desired keys to the locals hash, enclosing methods in anonymous procs/lambdas.

  As this example illustrates:

  ```rb
  get "/" do
    jade :index, :locals => {
      :stylesheet_path => proc {|_ignore, path| stylesheet_path(path) }
    }
  end
  ```

  Now, the `stylesheet_path` _function_ is available in the template:

  ```jade
  doctype 5
  html
    head
      link(href=stylesheet_path('app'), rel="stylesheet", type="text/css")
      link(href=stylesheet_path('mobile'), rel="stylesheet", type="text/css", media='screen and (min-width: 481px)')
      // (...)
  ```

  Remember that Jade is JavaScript, so the procs are converted to functions and thus require `()` after to be invoked.

  You can even expose the `haml` render method this way:

  ```ruby
  get "/crazy" do
    jade "!= haml('%p Mad crazy!')", :locals => { :haml => proc {|_ignore, tmpl| haml(tmpl) } }
  end

  ```

  This will output:
  ```html
  <p>Mad crazy!</p>
  ```

  Whether this is a good idea is another question! See performance considerations below.

  ## Performance

  The Ruby Racer performs data conversion when passing Ruby objects to the V8 context. This does not come for free
  and can quickly result in performance problems if not taken into consideration. The solution is to keep the
  `locals` hash as small and lightweight as possible. It is a good idea to calculate as much data as possible up front.

  I.e. an improved version of the `stylesheet_path` example above would determine the path to the needed stylesheets *before*
  invoking the template engine:

  ```
  jade :index, :locals => {
    :stylesheets => {
      :app => stylesheet_path('app'),
      :mobile => stylesheet_path('mobile')
    }
  }
  ```
  modifying the jade template to:

  ```jade
      link(href=stylesheets.app, rel="stylesheet", type="text/css")
      link(href=stylesheets.mobile, rel="stylesheet", type="text/css", media='screen and (min-width: 481px)')
      // (...)
  ```

  ## Author

  Bjørge Næss / [github.com/bjoerge](https://github.com/bjoerge)

  ## Credits

  All kudos in the world goes to TJ Holowaychuk for creating the eminent template language [Jade](http://jade-lang.com/) and to Charles Lowell for
  the amazing [Ruby Racer](https://github.com/cowboyd/therubyracer).

  ## LICENSE

  MIT