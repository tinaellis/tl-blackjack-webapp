require 'rubygems'
require 'sinatra'

# set :sessions, true

use Rack::Session::Cookie, :key => 'rack.session',
                            :path => '/',
                            :secret => 'brains'

# get '/' do
#   erb :new_player
# end

get '/' do
  if session["username"]
    redirect '/game'
  else
    redirect '/new_player'
  end
end

# controller (actions) does my verb and html match?
# do I need to push/pull data from model for persistence?

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  session[:username] = params[:username]
  redirect '/game'
end

# post '/bet_form' do
#   session["bet_amount"] = params["bet_amount"]
#   # redirect '/game'
#   erb :bet_form
# end

get '/game' do
  # create a deck and put it in session
  suits = ['H', 'D', 'C', 'S']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  session[:deck] = suits.product(values).shuffle!

  # deal cards
  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop   # player cards
  erb :game
end

post '/game' do
  if session[:game] == params[:hit]
    session[:player_cards] << session[:deck].pop
  end
  if session[:game] == params[:stay]
    #add up cards
  end
end

get '/game_over' do
  erb :game_over
end

