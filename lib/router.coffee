###
Router.configure
  layoutTemplate: 'appBody'
###

Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  @route 'join',
    path: '/join/:_id'
    render: 'join'
    onBeforeAction: ->
      Meteor.subscribe 'game', @params._id
      @next()
    data: ->
      game: Games.findOne()
      players: Players.find().fetch()

  @route 'game',
    path: '/game/:_id'
    render: 'game'