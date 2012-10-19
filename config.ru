require "rubygems"
require "bundler/setup"
require "./proxy"

set :run, false
set :raise_errors, true

run Sinatra::Application