findMe = (players) ->
  _.find players, (player) -> player._id is Meteor.userId()

Template.join.helpers
  playerClass: ->
    'text-success' if @gameMaster

  imGameMaster: ->
    findMe(@players)?.gameMaster

  btnStartClass: ->
    'disabled' if @game.minPlayers > @players.length or @players.length > @game.maxPlayers

  canJoin: ->
    @players.length < @game?.maxPlayers and not findMe(@players)

Template.join.events
  'click .btn-join': (event) ->
    event.preventDefault()
    Meteor.call 'joinGame', @game._id, (error) ->
      if error
        throw error