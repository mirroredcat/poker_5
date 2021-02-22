# 1 round
# shuffle the deck
# each player gets 5 cards
# 1 player open betting round
# players bet/fold
# players replace cards repetedly ask for discard
# players bet again
# if more than 1 player is left, they show cards
# winner takes pot

# played until only 1 player has money


# holds the deck
# tracks pot amount


require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'hand'

class Poker

  attr_reader :pot, :players, :deck, :current_player

  def initialize(player1, player2 = "Dan", player3 = 'Lance', player4 = 'Thibault')
    @pot = 0
    @deck = []
    @players = [Player.new(player1),
      Player.new(player2),
      Player.new(player3),
      Player.new(player4)]
    @betting_player = @players[0]
    @current_bet = 0

  end



  def next_player
    @players.rotate!
  end

  def round
    @deck = Deck.new
    @deck.shuffle

    deal_cards

    puts @betting_player.name
    puts
    render_hand(@betting_player)
    puts
    @current_bet = @betting_player.bet
    #first bet
    until @players.all?{|pl| pl.paid}
      player_bet
    end

    # discarding round
    @deck.discard
    discarding_round
    
    #nobody paid
    @players.each{|pl| pl.paid = false}

    #2nd bet
    until @players.all?{|pl| pl.paid}
      player_bet
    end

    winner = round_winner
    puts "#{winner.name} has won with"
    puts render_hand(winner)

    winner.pot += @pot

    @pot = 0
    @players.each{|pl| pl.paid = false}

    @players.rotate! until @players[0] == winner

  end

  def deal_cards
    4.times do
      @players[0].cards = @deck.deal
      next_player
    end
  end

  def player_bet
    initial_bet = @current_bet
    dude = @players[0]
    unless dude.skipped || dude.paid
      puts dude.name
      puts
      render_hand(dude)
      puts
      begin
        dude.next_move(@current_bet)
      rescue RuntimeError => e
        puts e
        retry
      end
    end
    @current_bet = dude.raised if dude.raised != 0
    if @current_bet != initial_bet
      @betting_player = dude
      @players.each{|pl| pl.paid = false unless pl == @betting_player}
    end
    next_player
  end

  def discarding_round
    @players.each do |pl|
      unless pl.skipped
        puts pl.name
        puts
        render_hand(pl)
        puts
        puts "Discard or skip?"
        answ = gets.chomp
        if answ == "discard"
          begin
            pl.discard
          rescue RuntimeError => e
            puts e
            retry
          end
          pl.cards.each_with_index{|card, i| pl.add_card(@deck.draw, i) if card == nil }
          puts "New cards:"
          render_hand(pl)
          puts
        end
      end
    end
  end

  def round_winner
    in_game = @players.select{|pl| !pl.skipped }
    if in_game.length == 1
      in_game[0]
    else
      compare = []
      in_game.each do |pl|  
        hand = Hand.new(pl.cards)
         compare << hand.score
      end
      i = hand_comparison(compare)
      in_game[i]
    end
  end

  def hand_comparison(hand_points)
    points = []
    comp = []
    hand_points.each do |hand|
      points << hand[0] 
      comp << hand[1]
    end
    if points.count(points.min) == 1
      points.find_index(points.min)
    else
      idx = []
      points.each_with_index do |el, i|
        idx << i if el == points.min
      end
      sel = []
      idx.each{|i| sel << comp[i]}
      t = sel.inject do |comp, el|
        case comp <=> el
        when -1
          comp
        when 1
          el
        end
      end
      comp.find_index(t)
    end
  end

  def render_hand(dude)
    puts dude.show_cards.map(&:render).join(" ")
    puts "1  2  3  4  5"
  end

  def game
    until win?
      round
    end
    player = @players.select{|pl| pl.pot != 0}
    puts "Hoozah! #{player.name} has won!"
    end

  def win?
    @players.select{|pl| pl.pot != 0}.length == 1
  end

end