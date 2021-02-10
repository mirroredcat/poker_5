require_relative 'card'

class Player

  attr_reader :name, :skipped
  attr_accessor :pot

  def initialize(name, cards, pot = 50)
    @name = name
    @cards = cards
    @pot = pot
    @skipped = false
  end

  def bet
    puts "How much would you like to bet?"
    gets.chomp.to_i
  end


  def next_move(bet_amount)
    puts 'What is your next move? fold/see/raise'
    answ = gets.chomp
    raise 'Not possible' unless ['fold', 'see', 'raise'].include?(answ)

    case answ
    when 'fold'
      toggle_skipped
    when 'see'
      @pot -= bet_amount
    when 'raise'
      val = raise_amount(bet_amount)
      @pot -= val
    end
  end

  def raise_amount(bet)
    puts 'How much?'
    val = gets.chomp.to_i
    raise 'Too little' unless val > bet

    val
  end

  def show_cards
    @cards
  end

  def toggle_skipped
    @skipped^=true
  end

end