require "spec_helper"
require 'rack/test'
require 'approvals'
require 'approvals/rspec'
require "sinatra/base"
require "tilt-jadeite/sinatra"

class JadeApp < Sinatra::Base
  set :root, File.dirname(__FILE__)+"/fixtures"

  set :jade, :cache => true

  helpers Sinatra::Jade

  helpers do
    def foo(what)
      "Foo says #{what}"
    end

    def play(artist, song)
      "Play #{song} from #{artist}"
    end

    def say_hello
      "Hello World!"
    end

    def development
      true
    end
  end

  get "/string" do
    jade 'p this is soo #{adjective.substring(0,5) + "in awesome"}', :locals => {:adjective => "freaky"}
  end

  get "/simple" do
    jade :simple, :locals => { :pageTitle => "Jade", :youAreUsingJade => true }
  end

  get "/include" do
    jade :include
  end

  get "/include_from_route" do
    jade "include fixtures/views/includes/head"
  end

  get "/helper_lambdas" do
    jade :helper_lambdas, :locals => {
      :foo => proc {|_,what| foo(what) },
      :play => proc {|_,artist, song| play(artist, song) },
      :say_hello => ->{ say_hello },
      :development => ->{ development? }
    }
  end

end

describe "Sinatra helper" do
  include Rack::Test::Methods

  def app
    JadeApp
  end

  it "renders a string" do
    verify :format => :html do
      get "/string"
      last_response.body
    end
  end

  it "renders a simple Jade template passing a couple of variables" do
    verify :format => :html do
      get "/simple"
      last_response.body
    end
  end

  it "handles includes of other Jade files" do
    verify :format => :html do
      get "/include"
      last_response.body
    end
  end

  it "handles includes from a jade template in the Sinatra route" do
    verify :format => :html do
      get "/include_from_route"
      last_response.body
    end
  end

  #it "calls helper methods on scope" do
    #get "/helper_lambdas"
    #last_response.status.should eq 200
    #verify :format => :html do
    #  last_response.body
    #end
  #end

  it "can cache files" do
    get "/helper_lambdas"
    #last_response.status.should eq 200
    verify :format => :html do
      last_response.body
    end
  end
end