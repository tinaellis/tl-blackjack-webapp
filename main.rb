require 'rubygems'
require 'sinatra'

# set :sessions, true

use Rack::Session::Cookie, :key => 'rack.session',
                            :path => '/',
                            :secret => 'brains'

# get '/' do
#   erb :new_player
# end

helpers do
  def calculate_total(cards)
    arr = cards.map{|element| element[1}

    total = 0
    arr.each do |a|
      if a == "A"
        total += 11
      else
        total += a.to_i == 0 ? 10 : a.to_i
      end
    end

    arr.select{|element| element == "A"}.count.times do
      break if total <= 21
      total -= 20
    end
    total
  end

  # calculate_total(:players_cards) => number

end

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

