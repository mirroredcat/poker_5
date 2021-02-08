class Hand
  
  def initialize(hand)
    @current_hand = hand
  end

  def sort_cards
    cards = []
    if @current_hand.length.odd?
      t = @current_hand.split("")
      t.each_with_index{|el, i|
        if el == "1"
          t[i] += t[i+1]
          t.delete_at(i+1)
          break
        end
      }
      t.each_slice(2){|el| cards << el}
    else
      @current_hand.split("").each_slice(2){|el| cards << el}
    end
    cards = cards.map{|val,sym| val.to_i == 0 ?  [translate(val), sym] : [val.to_i, sym] }
    cards.sort.reverse.map{|val,sym| val > 10 ? [translate_nr(val), sym] : [val, sym] }.join
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

  def translate_nr(nr)
    case nr
    when 11
      "J"
    when 12
      "Q"
    when 13
      "K"
    when 14
      "A"
    end
  end

end