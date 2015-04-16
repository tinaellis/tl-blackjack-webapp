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
    arr = cards.map{|element| element[1]}

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
      total -= 10
    end
    total
  end

  def card_image(card) # ['H', '4']
    suit = case card[0]
      when 'H' then 'hearts'
      when 'D' then 'diamonds'
      when 'C' then 'clubs'
      when 'S' then 'spades'
    end

    value = card[1]
    if ['J', 'Q', 'K', 'A'].include?(value)
      value = case card[1]
        when 'J' then 'jack'
        when 'Q' then 'queen'
        when 'K' then 'king'
        when 'A' then 'ace'
      end
    end

    "<img src='/images/cards/#{suit}_#{value}.jpg' class='card_image'>"
  end
end

before do
  @show_hit_or_stay_buttons = true
end

# calculate_total(:players_cards) => number

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
  if params[:username].empty?
    @error = "Name is required"
    halt erb(:new_Player)
  end
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

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
  player_total = calculate_total(session[:player_cards])
  if player_total == 21
    @sucess = "Contratulations! #{session[:username]} hit Blackjack!"
    @show_hit_or_stay_buttons = false
  elsif player_total > 21
    @error = "Sorry, it looks like #{session[:username]} busted."
    @show_hit_or_stay_buttons = false
  end
  erb :game
end

post '/game/player/stay' do
  @success = "#{session[:username]} has chosen to stay."
  @show_hit_or_stay_buttons = false
  @dealers_next_card = true
  redirect '/game/dealer'
end

get '/game/dealer' do
  @show_hit_or_stay_buttons = false
  dealer_total = calculate_total(session[:dealer_cards])

  if dealer_total == 21
    @error = "Sorry, dealer hit Blackjack."
    @play_again = true

  elsif dealer_total > 21
    @success = "Congratulations, it looks like the dealer has busted."
    @play_again = true

  elsif dealer_total >= 17
    redirect '/game/compare'
  else
    @show_dealer_hit_button = true
  end

  erb :game
end

post '/game/dealer/hit' do
  session[:dealer_cards] << session[:deck].pop
  redirect '/game/dealer'
end

get '/game/compare' do
  player_total = calculate_total(session[:player_cards])
  dealer_total = calculate_total(session[:dealer_cards])
  @play_again = true
  if player_total < dealer_total
    @error = "Sorry, you lost.."
  elsif player_total > dealer_total
    @error = "Congrats, you won!"
  else
    @success = "It's a tie"
  end
  erb :game

end


