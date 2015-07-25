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
    onBeforeAction: ->
      Meteor.subscribe 'game', @params._id
      @next()
    data: ->
      players = Players.find().fetch()
      me = _.find players, (player) -> player._id is Meteor.userId()
      game: Games.findOne()
      players: players
      me: me