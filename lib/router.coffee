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
    ###onBeforeAction: ->
    @me = new Meteor.Collection 'me'
    Meteor.subscribe 'games'
    Meteor.subscribe 'players', @params._id
    @next()###
    data: ->
      players = TraitorPlayers.find(gameKey: @params._id).fetch()
      game: TraitorGames.findOne @params._id
      players: players
      me: _.find players, (player) -> player._id is Meteor.userId()