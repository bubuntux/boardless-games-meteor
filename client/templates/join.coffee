findMe = (players) ->
  if Meteor.userId()
    _.find players, (player) -> player._id is Meteor.userId()

Template.join.helpers
  btnClass: ->
    me = findMe(@players)
    if me
      if not me.gameMaster
        'disabled'
      else if @game.minPlayers > @players.length or @players.length > @game.maxPlayers
        'disabled'

  btnText: ->
    me = findMe(@players)
    if not me
      'Join'
    else if me.gameMaster
      'Start Game'

  showBtn: ->
    if not Meteor.user()
      false
    else
      me = findMe(@players)
      if not me
        true
      else if me.gameMaster
        true
      else
        false

Template.join.events
  'click .btn:not(.disabled)': (event, template) ->
    event.preventDefault()
    Meteor.call 'joinGame', @game._id, (error, result) ->
      if error
        throw error