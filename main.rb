require 'rubygems'
require 'sinatra'

# set :sessions, true

use Rack::Session::Cookie, :key => 'rack.session',
                            :path => '/',
                            :secret => 'brains'

get '/' do
  redirect "/form"
end

get '/form' do
  erb :form
end

post '/bet' do
  params['username']
end

get '/bet' do
  erb :bet
end


