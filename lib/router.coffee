###
Router.configure
  layoutTemplate: 'appBody'
###

Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  @route 'game',
    path: '/game/:_id'
    render: 'game'
#onBeforeAction: -> #TODO subscribe
    data: ->
      game = Games.findOne(@params._id)
      players = Players.find({_id: {$in: game.players}}).fetch()
      game: game
      players: players
      me: players[0] #TODO