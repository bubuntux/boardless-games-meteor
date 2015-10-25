Template.love_letters.onRendered ->
  myScroll = new IScroll('#screens',
    mouseWheel: true
    click: true
    snap: '.screen') # TODO check?

Template.love_letters.onCreated ->
  @.autorun ->
    me = _.find(Template.currentData().players, (p) -> p.id is Meteor.userId())
    Session.set 'me', me
    Session.set 'myTurn', me?.cards.length > 1

Template.love_letters.helpers
  gameCard: ->
    _.sortBy LoveLettersCards, (c) -> -c.value
  cardCount: ->
    count = 0
    for card in Template.parentData().playedCards
      count++ if card is @.value
    count
  myCards: ->
    cardValues = _.find(@players, (p) -> p.id is Meteor.userId()).cards
    _.map cardValues, (c) -> value: c, name: LoveLettersCards[c - 1].name # TODO -1 =/
  myTurn: ->
    Session.get 'myTurn'
  cardClass: ->
    if @.value is Guard.value then 'disabled' else ' '
  playerClass: ->
    if @.protected
      return 'text-info'
    if @.cards.length > 1
      return 'text-success'
    if @.cards.length is 0
      return 'text-danger'
    return ' '
  peek: ->
    me = Session.get 'me'
    '(' + LoveLettersCards[@.cards[0] - 1].name + ')' if me?.see is @.id

Template.love_letters.events
  'touchmove': (event) ->
    event.preventDefault()
  'click .btn-play': (event, template) ->
    event.preventDefault()
    card = parseInt template.find('input:radio[name=myCardRadio]:checked')?.value
    otherPlayerId = template.find('input:radio[name=playerRadio]:checked')?.value
    guessCard = parseInt template.find('input:radio[name=cardRadio]:checked')?.value
    Meteor.call 'love_letters_play', @_id, card, otherPlayerId, guessCard, (error) -> alert error if error