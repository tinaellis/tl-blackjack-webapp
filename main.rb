require 'rubygems'
require 'sinatra'

# set :sessions, true

use Rack::Session::Cookie, :key => 'rack.session',
                            :path => '/',
                            :secret => 'brains'

BLACKJACK_AMOUNT = 21
DEALER_MIN_HIT = 17

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

  def bet_win!(msg)
    # session[:max_bet] = 500
    @bet_win = session[:max_bet] - session[:bet_amount] = session[:max_bet]
  end

  def bet_lose!(msg)
    # session[:max_bet] = 500
    @bet_lose = session[:max_bet] - session[:bet_amount] = session[:max_bet]
  end

  def winner!(msg)
    @success = "<strong>#{session[:username]} wins!</strong> #{msg}"
    @show_hit_or_stay_buttons = false
    @play_again = true
  end

  def loser!(msg)
    @error = "<strong>#{session[:username]} loses!</strong> #{msg}"
    @show_hit_or_stay_buttons = false
    @play_again = true
  end

  def tie!(msg)
    @success = "<strong>It's a tie!</strong> #{msg}"
    @show_hit_or_stay_buttons = false
    @play_again = true
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
  session[:max_bet] = 500
  redirect '/bet_form'
end

get '/bet_form' do
  erb :bet_form
end

post '/bet_form' do
  if params[:bet_amount].empty?
    @error = "Amount is required"
    halt erb(:bet_form)
  end
  session[:bet_amount] = params[:bet_amount]
  redirect '/game'
end

get '/game' do
  session[:turn] = session[:username]

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

  if player_total == BLACKJACK_AMOUNT
    winner!("Congratulations! #{session[:username]} has hit Blackjack!!")
    bet_win!("Player's bet total is #{session[:max_bet]}.")
  elsif player_total > BLACKJACK_AMOUNT
    loser!("#{session[:username]} has busted with a total of #{player_total}.")
    bet_lose!("Player's bet total is #{session[:max_bet]}.")
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
  session[:turn] = "dealer"
  dealer_total = calculate_total(session[:dealer_cards])

  if dealer_total == BLACKJACK_AMOUNT
    loser!("Sorry, dealer hit Blackjack.")
    bet_lose!("Player's bet total is #{session[:max_bet]}.")
  elsif dealer_total > BLACKJACK_AMOUNT
    winner!("Dealer busted with #{dealer_total}!")
    bet_win!("Player's bet total is #{session[:max_bet]}.")
  elsif dealer_total >= DEALER_MIN_HIT
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

  if player_total < dealer_total
    loser!("#{session[:username]} stayed at #{player_total}, and the dealer stayed at #{dealer_total}.")
    bet_lose!("Player's bet total is #{session[:max_bet]}.")
  elsif player_total > dealer_total
    winner!("#{session[:username]} has stayed at #{player_total} and the dealer stayed at #{dealer_total}.")
    bet_win!("Player's bet total is #{session[:max_bet]}.")
  else
    tie!("Both #{session[:username]} and the dealer stayed at #{player_total}.")
  end
  erb :game
end

get '/game_over' do
  erb :game_over
end


