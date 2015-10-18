Template.love_letters.helpers
  cards: ->
    LoveLettersCards
  cardCount: ->
    count = 0
    for card in Template.parentData().playedCards
      if card.value is @.value
        count++
    count
  myCards: ->
    cardValues = _.find(@players, (p) -> p.id is Meteor.userId()).cards
    _.map cardValues, (c) -> LoveLettersCards[c - 1].name # TODO -1 =/
  myTurn: ->
    _.find(@players, (p) -> p.id is Meteor.userId()).cards.length >= 2

Template.love_letters.events
  'click .btn-play': (event) ->
    event.preventDefault()