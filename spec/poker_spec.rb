require 'rspec'
require 'card'
require 'deck'

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

  describe '#use_card' do
    it "changed the card from unused to used" do
      card.use_card
      expect(card.used).to eq(true)
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
  let(:card) {double("card")}

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
    it "removes 5 cards from the deck" do
      deck.deal
      expect(deck.cards_left).to_not eq(initial_deck)
      expect(initial_deck - deck.cards_left).to eq(5)
    end

    it 'returns the 5 cards'


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

end