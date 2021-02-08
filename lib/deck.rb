require_relative 'card'

class Deck

  @@suits = ["\u2664", "\u2661", "\u2667", "\u2662"]
  @@ordered_deck = @@suits.product((2..10).chain(%w(J Q K A)).to_a)
  # 2.times {@@ordered_deck << [nil,"JOKER"]}
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
    @deck.count
  end

  def deal
    deal_pack = []
    5.times {deal_pack << @deck.shift}
    deal_pack
  end

  def draw
    @deck.shift
  end

  def discard
    @deck.delete_at(0)
  end

end