require 'rspec'
require 'card'
require 'deck'
require 'hand'

describe Card do
  subject(:card) {Card.new(2, "\u2664")}

  describe '#initialize' do
    it 'returns the card value' do
      expect(card.value).to eq(2)
    end

    it 'returns the card symbol' do
      expect(card.sym).to eq("\u2664")
    end
  end 


  describe '#render' do
   it "prints the card value and symbol" do
    expect(card.render).to eq("2♤")
   end

  end 

end



describe Deck do
  subject(:deck) {Deck.new}
  let(:card1) {double("card", :value => 2, :sym =>"♤" )}

  describe '#initialize' do

    it "contains 52 card" do
      expect(deck.deck.length).to eq(52)
    end

  end 

  describe "#to_s" do
    it "has a string with card order in deck" do
      expect(deck.to_s).to eq("2♤3♤4♤5♤6♤7♤8♤9♤10♤J♤Q♤K♤A♤2♡3♡4♡5♡6♡7♡8♡9♡10♡J♡Q♡K♡A♡2♧3♧4♧5♧6♧7♧8♧9♧10♧J♧Q♧K♧A♧2♢3♢4♢5♢6♢7♢8♢9♢10♢J♢Q♢K♢A♢")
    end
  end

  describe '#shuffle' do
    let!(:original_deck) {deck.to_s}
    it "shuffles the cards" do
      deck.shuffle
      expect(deck.to_s).to_not eq(original_deck)
    end
  end

  describe '#deal' do
    let!(:initial_deck) {deck.cards_left}
    let(:card2) {double("card", :value => 3, :sym =>"♤" )}
    let(:card3) {double("card", :value => 4, :sym =>"♤" )}
    let(:card4) {double("card", :value => 5, :sym =>"♤" )}
    let(:card5) {double("card", :value => 6, :sym =>"♤" )}

    it "removes 5 cards from the deck" do
      deck.deal
      expect(deck.cards_left).to_not eq(initial_deck)
      expect(initial_deck - deck.cards_left).to eq(5)
    end

    it 'returns the 5 cards' do
      allow(deck).to receive(:deal).and_return([card1,card2,card3,card4,card5])
      expect(deck.deal).to eq([card1,card2,card3,card4,card5])
    end

  end


  describe '#cards_left' do
    it "returns initial number of unused cards" do
      expect(deck.cards_left).to eq(52)
    end

    it "returns the number of unused card after deals" do
      deck.deal
      deck.deal
      expect(deck.cards_left).to eq(42)
    end
  end

  describe '#draw' do

    it 'returns a single card' do
      allow(deck).to receive(:draw).and_return(card1)
      expect(deck.draw).to eq(card1)
    end


    it 'decreases the deck by 1' do
      deck.deal
      deck.deal
      deck.draw
      deck.draw
      expect(deck.cards_left).to eq(40)
    end
  end

  describe '#discard' do

    it 'discards one card without returning it' do
      deck.deal
      deck.deal
      deck.draw
      deck.draw
      deck.discard
      expect(deck.cards_left).to eq(39)
    end
  end
end


describe Hand do
  let(:card1) {double("card", :value => "J", :sym =>"♤" )} #card1  J♤
  let(:card2) {double("card", :value => 10, :sym =>"♤" )}  #card2  10♤
  let(:card3) {double("card", :value => 9, :sym =>"♤" )}   #card3  9♤  
  let(:card4) {double("card", :value => 8, :sym =>"♤" )}   #card4  8♤
  let(:card5) {double("card", :value => 7, :sym =>"♤" )}   #card5  7♤

  let(:card6) {double("card", :value => 8, :sym =>"♡" )}   #card6  8♡
  let(:card7) {double("card", :value => 8, :sym =>"♧" )}   #card7  8♧
  let(:card8) {double("card", :value => 8, :sym =>"♢" )}   #card8  8♢

  let(:card9) {double("card", :value => 7, :sym =>"♢" )}   #card9  7♢

  let(:card10) {double("card", :value => "K", :sym =>"♤" )}#card10 K♤
  let(:card11) {double("card", :value => 2, :sym =>"♤" )}  #card11 2♤

  let(:card12) {double("card", :value => 6, :sym =>"♢" )}  #card12 6♢
  let(:card13) {double("card", :value => 5, :sym =>"♢" )}  #card13 5♢


  subject(:hand) {Hand.new([card12,card8,card10, card11, card13 ])} # 6♢8♢K♤2♤5♢  hugh card, sorted val

  describe '#score' do
    let(:hand2) {Hand.new([card3,card2,card5,card1,card4])} # 9♤10♤7♤J♤8♤ straight flush, max val
    let(:hand3) {Hand.new([card4,card10,card7,card6,card13])} # 8♤K♤8♧8♡5♢  3 of kind, val
    let(:hand4) {Hand.new([card5,card4,card9,card6,card7])} # 7♤8♤7♢8♡8♧ full house, 3,2
    let(:hand5) {Hand.new([card4, card1,card8,card6,card7])} # 8♤J♤8♢8♡8♧  4 of kind, val

    it 'returns appropriate score for hand and comparing value' do
      expect(hand.score).to eq([9,[13,8,6,5,2]])
      expect(hand2.score).to eq([1, 11])
      expect(hand3.score).to eq([6,8])
      expect(hand4.score).to eq([3,[8,7]])
      expect(hand5.score).to eq([2, 8])
    end

  end

  describe '#sort_cards' do
    let(:hand2) {Hand.new([card3,card2,card5,card1,card4])} # 9♤10♤7♤J♤8♤
    it 'orderes cards by value' do
      expect(hand2.sort_cards).to eq([11,10,9,8,7])
    end
  end

  describe '#pair' do
    let(:hand2) { Hand.new([card13,card7,card10,card8,card11]) } # 5♢8♧K♤8♢2♤

    it 'returns true if hand contains a pair' do
      expect(hand2.pair).to eq(true)
    end

    it 'returns false if hand contains no pairs' do
      expect(hand.pair).to eq(false)
    end
  end

  describe '#three' do
    let(:hand2) { Hand.new([card6,card7,card10,card8,card11]) } # 8♡8♧K♤8♢2♤
    it 'returns true if hand contains 3 of the same' do
      expect(hand2.three).to eq(true)
    end

    it 'returns false if hand does not have 3 of the same cards' do
      expect(hand.three).to eq(false)
    end
  end

  describe '#four' do
    let(:hand2) { Hand.new([card6,card7,card10,card8,card4]) } # 8♡8♧K♤8♢8♤
    it 'returns true if hand contains 4 of a kind' do
      expect(hand2.four).to eq(true)
    end
    
    it 'returns false if hand does not contain 4 of a kind' do
      expect(hand.four).to eq(false)
    end

  end

  describe '#same_symbol' do
    let(:hand2) { Hand.new([card10, card11, card4, card5, card2]) } # K♤2♤8♤7♤10♤
    it 'returns true if hand has same symbol' do
      expect(hand2.same_symbol).to eq(true)
    end

    it 'returns false if hand has different symbols' do
      expect(hand.same_symbol).to eq(false)
    end

  end

  describe '#consecutive' do
    let(:hand2) { Hand.new([card3,card2,card5,card1,card4]) } # 9♤10♤7♤J♤8♤
    it 'returns true if all cards are consecutive' do
      expect(hand2.consecutive).to eq(true)
    end

    it 'returns false if cards are not consecutive' do
      expect(hand.consecutive).to eq(false)
    end

  end
end