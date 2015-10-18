Template.love_letters.helpers
  cards: ->
    LoveLettersCards
  cardCount: ->
    count = 0
    for card in Template.parentData().playedCards
      if card.value is @.value
        count++
    count
