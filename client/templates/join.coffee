findMe = (players) ->
  _.find players, (player) -> player._id is Meteor.userId()

Template.join.helpers
  playerClass: ->
    if @gameMaster
      'text-success'

  imGameMaster: ->
    me = findMe(@players)
    me?.gameMaster

  btnStartClass: ->
    if @game.minPlayers > @players.length or @players.length > @game.maxPlayers
      'disabled'

  canJoin: ->
    @players.length <= @game?.maxPlayers and not findMe(@players)

Template.join.events
  'click .btn-join:not(.disabled)': (event) ->
    event.preventDefault()
    Meteor.call 'joinGame', @game._id, (error) ->
      if error
        throw error