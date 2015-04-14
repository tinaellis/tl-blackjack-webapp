require 'rubygems'
require 'sinatra'

# set :sessions, true

use Rack::Session::Cookie, :key => 'rack.session',
                            :path => '/',
                            :secret => 'brains'

get '/' do
  erb :form
end

# controller (actions) does my verb and html match?
# do I need to push/pull data from model for persistence?

post '/form' do
  session["username"] = params["username"]
  redirect '/bet_form'
end

post '/bet_form' do
  erb :bet_form
end

post 'bet_form' do
  session["bet_amount"] = params["bet_amount"]
  redirect '/game_play'
end

post '/game_play' do
  erb :game_play
end

get '/game_over' do
  erb :game_over
end

