require_relative 'card'

class Player

  attr_reader :name, :skipped

  def initialize(name, cards)
    @name = name
    @cards = cards
    @skipped = false
  end


  def show_cards
    @cards
  end

end