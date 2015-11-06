_scroller = undefined
_boardMode = false
_gameId = undefined

_myTurn = -> Session.get 'myTurn'

_selectPlayer = (event, template) ->
  template.find('.player .btn.btn-default.active')?.className = 'btn btn-default'
  event.currentTarget.className = 'btn btn-default active'

_selectCard = (screen, event, template) ->
  template.find(screen + ' .card.selected')?.className = 'card'
  event.currentTarget.className = 'card selected'

Template.love_letters.onCreated ->
  _gameId = Template.currentData()._id

Template.love_letters.onRendered ->
  new WOW().init()
  _scroller = new IScroll('#screens',
    mouseWheel: true
    snap: '.screen'
  )

  if window.DeviceOrientationEvent
    window.addEventListener 'deviceorientation', (data)->
      boardMode = data.beta < 50
      if boardMode is _boardMode
        return
      if boardMode
        _scroller.scrollToElement '#played-cards'
        if _myTurn()
          card = parseInt(_.first($('#hand .card.selected input'))?.value)
          if card
            otherPlayerId = _.first($('#player-selection .player .btn.active').parent().find('input'))?.value
            guessCard = parseInt(_.first($('#card-selection .card.selected input'))?.value)
            Meteor.call 'love_letters_play', _gameId, card, otherPlayerId, guessCard, (error) ->
              if error
                alert error
              else
                _.each $('.card.selected'), (el) -> el.className = 'card'
                _.each $('.btn.active'), (el) -> el.className = 'btn btn-default'
      else
        _scroller.scrollToElement '#hand'
      _boardMode = boardMode
      console.log('algo') #_scroller.refresh()
  else
    alert("DeviceOrientation is NOT supported")

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
  actionClass: ->
    me = Session.get('me')
    if me?.protected
      return 'protected'
    if me?.cards.length > 1
      return 'turn'
    if me?.cards.length is 0
      return 'out'
    return ''
  dontHave: ->
    me = Session.get 'me'
    me?.dontHave
  peek: ->
    me = Session.get 'me'
    if me?.see
      player =_.find(@players, (p) -> p.id is me.see)
      if player
        return name: player.name, card: player.cards[0]

Template.love_letters.events
  'touchmove': (event) ->
    event.preventDefault()
  'tap #hand .card': (event, template) ->
    event.preventDefault()
    if _myTurn()
      _selectCard('#hand', event, template)
  'tap #card-selection .card': (event, template) ->
    event.preventDefault()
    if _myTurn()
      _selectCard('#card-selection', event, template)
  'tap .player .btn': (event, template) ->
    event.preventDefault();
    if _myTurn()
      _selectPlayer(event, template)
  'click .player .btn': (event, template) -> # TODO remove?
    event.preventDefault();
    if _myTurn()
      _selectPlayer(event, template)
