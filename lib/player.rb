require_relative 'card'

class Player

  attr_reader :name, :skipped, :raised
  attr_accessor :pot, :paid, :cards

  def initialize(name, cards = [], pot = 50)
    @name = name
    @cards = cards
    @pot = pot
    @skipped = false
    @paid = false
    @raised = 0
  end

  def bet
    puts "How much would you like to bet?"
    puts "Your balance is #{@pot}"
    amount = gets.chomp.to_i
    @pot -= amount
    @paid = true
    amount
  end


  def next_move(bet_amount)
    puts 'What is your next move? fold/see/raise'
    puts "Your balance is #{@pot}"
    answ = gets.chomp
    raise 'Not possible' unless ['fold', 'see', 'raise'].include?(answ)

    case answ
    when 'fold'
      toggle_skipped
      @raised = 0
    when 'see'
      @pot -= bet_amount
      @raised = 0
    when 'raise'
      @raised = raise_amount(bet_amount)
      @pot -= @raised
    end
    @paid = true
  end

  def raise_amount(bet)
    puts 'How much?'
    val = gets.chomp.to_i
    raise 'Too little' if val < bet
    val
  end

  def discard
    puts 'Select card indeces with spaces in between'
    x = gets.chomp.split.map(&:to_i)
    raise 'Not allowed' if x.any?{|el| el < 1 || el > @cards.length}
    x.each do |el|
      @cards[el-1] = nil
    end
  end

  def add_card(card, i)
    @cards[i] = card
  end

  def show_cards
    @cards
  end

  def toggle_skipped
    @skipped^=true
  end


end