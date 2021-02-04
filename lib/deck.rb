require_relative 'card'

class Deck

  @@suits = ["\u2664", "\u2661", "\u2667", "\u2662"]
  @@ordered_deck = @@suits.product((2..10).chain(%w(J Q K A)).to_a)

  attr_reader :deck

  def initialize 
    @deck = @@ordered_deck.map{|sym,val| Card.new(val,sym) }
  end

  def to_s
    @deck.map(&:render).join('')
  end

  def shuffle
    @deck.shuffle!
  end

  def cards_left
    @deck.count{|card| !card.used}
  end

  def deal
    deal_pack = []
    5.times do
      deal_pack << @deck.shift
      deal_pack[-1].use_card
    end
    deal_pack
  end

end