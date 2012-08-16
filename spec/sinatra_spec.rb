require "spec_helper"
require 'rack/test'
require 'approvals'
require 'approvals/rspec'
require "sinatra/base"
require "tilt-jadeite/sinatra"

class JadeApp < Sinatra::Base
  set :root, File.dirname(__FILE__)+"/fixtures"

  helpers Sinatra::Jade

  get "/simple" do
    jade :simple, :locals => { :pageTitle => "Jade", :youAreUsingJade => true }
  end

  get "/include" do
    jade :include
  end

end

describe "Sinatra helper" do
  include Rack::Test::Methods

  def app
    JadeApp
  end

  it "It renders a simple Jade template passing a couple of variables" do
    verify :format => :html do
      get "/simple"
      last_response.body
    end
  end

  it "It handles includes of other Jade files" do
    verify :format => :html do
      get "/include"
      last_response.body
    end
  end

end