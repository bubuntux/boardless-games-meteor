Template.join.helpers
  playerClass: ->
    'text-success' if @gameMaster

  imGameMaster: ->
    @me?.gameMaster

  btnStartClass: ->
    'disabled' if TraitorConstant.MIN_PLAYERS > @players.length or @players.length > TraitorConstant.MAX_PLAYERS

  canJoin: ->
    @players.length < TraitorConstant.MAX_PLAYERS and not @me and Meteor.user()

Template.join.events
  'click .btn-join': (event) ->
    event.preventDefault()
    Meteor.call 'joinGame', @game._id, (error) -> throw error if error

  'click .btn-start:not(.disabled)': ->
    event.preventDefault()
    Meteor.call 'startGame', (error) -> throw error if error
