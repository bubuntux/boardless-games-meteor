Template.love_letters.onRendered ->
  @.data.scroll = new IScroll('#screens',
    mouseWheel: true
    snap: '.screen'
  )
  new WOW().init()

Template.love_letters.onCreated ->
  @.autorun ->
    me = _.find(Template.currentData().players, (p) -> p.id is Meteor.userId())
    Session.set 'me', me
    Session.set 'myTurn', me?.cards.length > 1

Template.love_letters.helpers
  gameCard: ->
    _.sortBy LoveLettersCards, (c) -> -c.value
  playedCards: ->
    Session.get('me')?.playedCards
  myCards: ->
    _.find(@players, (p) -> p.id is Meteor.userId()).cards

  cardCount: ->
    count = 0
    for card in Template.parentData().playedCards
      count++ if card is @.value
    count
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

_selectPlayer = (event, template, data) ->
  event.preventDefault();
  if Session.get 'myTurn'
    template.find('.player .btn.btn-default.active')?.className = 'btn btn-default'
    event.currentTarget.className = 'btn btn-default active'
    data.selectedPlayer = event.currentTarget.parentElement.lastChild.value

_selectCard = (screen, event, template) ->
  event.preventDefault()
  if Session.get 'myTurn'
    template.find(screen + ' .card.selected')?.className = 'card'
    event.currentTarget.className = 'card selected'
    parseInt(event.currentTarget.lastChild.value) #TODO watch out

Template.love_letters.events
  'touchmove': (event) ->
    event.preventDefault()
  'tap #hand .card': (event, template) ->
    @.selectedCard = _selectCard('#hand', event, template)
  'tap #card-selection .card': (event, template, data) ->
    @.guessCard = _selectCard('#card-selection', event, template)
  'tap .player .btn': (event, template) ->
    _selectPlayer(event, template, @)
  'click .player .btn': (event, template) ->
    _selectPlayer(event, template, @)

  'click .btn-play': (event, template) ->
    event.preventDefault()
    card = parseInt template.find('input:radio[name=myCardRadio]:checked')?.value
    otherPlayerId = template.find('input:radio[name=playerRadio]:checked')?.value
    guessCard = parseInt template.find('input:radio[name=cardRadio]:checked')?.value
    Meteor.call 'love_letters_play', @_id, card, otherPlayerId, guessCard, (error) -> alert error if error
