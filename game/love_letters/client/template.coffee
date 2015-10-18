Template.love_letters.onCreated ->
  me = _.find(@data.players, (p) -> p.id is Meteor.userId())
  Session.set 'me', me
  Session.set 'myTurn', me?.cards.length > 1

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
    _.map cardValues, (c) -> value: c, name: LoveLettersCards[c - 1].name # TODO -1 =/
  myTurn: ->
    Session.get 'myTurn'

Template.love_letters.events
  'click .btn-play': (event, template) ->
    event.preventDefault()
    card = parseInt template.find('input:radio[name=myCardRadio]:checked').value
    otherPlayerId = template.find('input:radio[name=playerRadio]:checked').value
    guessCard = parseInt template.find('input:radio[name=cardRadio]:checked').value
    Meteor.call 'love_letters_play', @_id, card, otherPlayerId, guessCard, (error) -> alert error if error