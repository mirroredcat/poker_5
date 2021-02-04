class Card

  attr_reader :value, :sym, :used
  def initialize(value, sym)
    @value = value
    @sym = sym
    @used = false
    
  end

  def render
    "#{value}#{sym}"
  end

  def use_card
    @used = true
  end


end 