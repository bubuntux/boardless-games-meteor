Template.join.helpers
  playerClass: ->
    'text-success' if @gameMaster

  imGameMaster: ->
    @me?.gameMaster

  btnStartClass: ->
    #'disabled' if @game.minPlayers > @players.length or @players.length > @game.maxPlayers

  canJoin: ->
    @players.length < @game?.maxPlayers and not @me and Meteor.user()

  startGame: ->
    if @game?.state?
      Router.go 'game', _id: @game._id

Template.join.events
  'click .btn-join': (event) ->
    event.preventDefault()
    Meteor.call 'joinGame', @game._id, (error) ->
      if error
        throw error

  'click .btn-start:not(.disabled)': ->
    event.preventDefault()
    Meteor.call 'startGame', (error, gameKey) ->
      if error
        throw error
      Router.go 'game', _id: gameKey