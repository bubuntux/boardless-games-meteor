###
Router.configure
  layoutTemplate: 'appBody'
###

Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  ###onBeforeAction: ->
  @me = new Meteor.Collection 'me'
  Meteor.subscribe 'games'
  Meteor.subscribe 'players', @params._id
  @next()###
  @route 'game',
    path: '/game/:_id'
    render: 'game'
    data: ->
      gameKey = @params._id
      players = TraitorPlayers.find(gameKey: gameKey).fetch()
      game: TraitorGames.findOne gameKey
      players: players
      me: _.find players, (player) -> player._id is Meteor.userId()