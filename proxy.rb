require "sinatra"
require 'sinatra/synchrony'
require 'faraday'
require 'eventmachine'
require 'net/http'
require 'pp'

# Set the destination based on an Environment Variable
set :destination, ENV['DESTINATION']

# Build The Connection
set :connection, (Faraday::Connection.new(url: settings.destination) do |builder|
  builder.use Faraday::Adapter::EMSynchrony # make http request with eventmachine and synchrony
end)

# All Paths Hit the Proxy
get '/*' do |path|
  proxy(path)
end

put '/*' do |path|
  proxy(path)
end

patch '/*' do |path|
  proxy(path)
end

options '/*' do |path|
  proxy(path)
end

delete '/*' do |path|
  proxy(path)
end

# Proxy the response to the destination
def proxy(path)

  # Determine the Request Method
  verb = request.env['REQUEST_METHOD'].downcase.to_sym

  # Get the Response From the Proxy
  response = eval "settings.connection.#{verb} '#{path}'"

  # Return the Proxy Response Headers
  headers response.headers

  # Return the Proxy Response Body
  body response.body
end


