require_relative 'card'

class Hand
  attr_reader :current_hand
  def initialize(hand)
    @current_hand = hand
  end

  def score
    vals = sort_cards
    if three && pair
      th = vals.select { |e| vals.count(e) == 3 }
      pa = vals.select { |e| vals.count(e) == 2 }
      [3, [th[0],pa[0]]]
    elsif pair
      el = []
      vals.each{|e| el << e if vals.count(e) == 2 && !el.include?(e)}
      if el.length == 1
        vals.delete(el[0])
        [8, el + vals ]
      else
        vals.reject!{|t| el.include?(t)}
        [7, el + vals]
      end
    elsif three
      el = []
      vals.each{|e| el << e if vals.count(e) == 3 && !el.include?(e)}
      vals.delete(el[0])
      [6, e + vals]
    elsif four
      el = []
      vals.each{|e| el << e if vals.count(e) == 4 && !el.include?(e)}
      vals.delete(el[0])
      [2 , e + vals]
    elsif same_symbol && !consecutive
      [ 4, vals.sort.reverse]
    elsif consecutive && !same_symbol
      [ 5, vals.max]
    elsif same_symbol && consecutive
      [ 1, vals.max]
    else
      [ 9, vals.sort.reverse]
    end
  end

  def sort_cards #translate and order values
    get_values.map!{|el| !el.is_a?(Integer) ? translate(el) : el}.sort.reverse
  end

  def pair
    t = sort_cards
    t.each {|el| return true if t.count(el) == 2}
    false
  end

  def three
    t = sort_cards
    t.each {|el| return true if t.count(el) == 3}
    false
  end

  def four
    t = sort_cards
    t.each {|el| return true if t.count(el) == 4}
    false
  end

  def same_symbol
    syms = []
    @current_hand.each{|card| syms << card.sym}
    syms.uniq.length == 1
  end

  def consecutive
    t = sort_cards.reverse
    t == (t[0]..t[-1]).each.to_a
  end

  private

  def get_values
    values = []
    @current_hand.each{|card| values << card.value}
    values
  end


  def translate(lttr)
    case lttr
    when "J"
      11
    when "Q"
      12
    when "K"
      13
    when "A"
      14
    end
  end


end