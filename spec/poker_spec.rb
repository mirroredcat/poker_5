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
  subject(:hand) {Hand.new("2♤3♤4♤5♤")}

  describe '#score' do
    it 'returns appropriate score for hand'

  end

  describe '#translate' do
    it 'turns J-Q-K-A into integers' do
      expect(hand.translate("A")).to eq(14)
      expect(hand.translate("J")).to eq(11)
      expect(hand.translate("Q")).to eq(12)
      expect(hand.translate("K")).to eq(13)
    end

  end

  describe '#sort_cards' do
  let(:hand2) {Hand.new('10♤K♡J♧Q♢')}
    it 'orderes cards by value' do
      
      expect(hand2.sort_cards).to eq('K♡Q♢J♧10♤')
    end
  end

  describe '#pair' do

    it 'returns true if hand contains a pair'

    it 'returns false if hand contains no pairs'
  end

  describe '#three' do
    it 'returns true if hand contains 3 of the same'

    it 'returns false if hand does not have 3 of the same cards'

  end

  describe '#same_symbol' do
    it 'returns true if hand has same symbol'

    it 'returns false if hand has different symbols'

  end

  describe '#consecutive' do
    it 'returns true if all cards are consecutive'

    it 'returns false if cards are not consecutive'

  end
end