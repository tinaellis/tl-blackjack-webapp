require 'rubygems'
require 'sinatra'

# set :sessions, true

use Rack::Session::Cookie, :key => 'rack.session',
                            :path => '/',
                            :secret => 'brains'


get '/' do
  "Good morning World!"
end

get '/spiderman' do
  erb :spiderman
end

post '/forms/login' do
  erb :forms
end
