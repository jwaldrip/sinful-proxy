require "sinatra"
require 'sinatra/synchrony'
require 'faraday'
require 'eventmachine'
require 'net/http'
require 'pp'
require 'uri'

set :destination, 'http://minecraft.waldrip.net:8123'
set :connection, (Faraday::Connection.new(url: settings.destination) do |builder|
  builder.use Faraday::Adapter::EMSynchrony # make http request with eventmachine and synchrony
  #builder.use Faraday::Response::Yajl       # parse body with yajl
end)

get '/*' do |path|
  proxy path
end

put '/*' do |path|
  proxy path
end

patch '/*' do |path|
  proxy path
end

options '/*' do |path|
  proxy path
end

delete '/*' do |path|
  proxy path
end

def proxy path
  verb = request.env['REQUEST_METHOD'].downcase.to_sym
  full_path = [settings.destination, path].join('/')
  response = eval "settings.connection.#{verb} '#{full_path}'"
  headers response.headers
  body response.body
end


