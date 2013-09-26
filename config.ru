require './server'
use Rack::Cache
use Rack::Deflater
run Sinatra::Application