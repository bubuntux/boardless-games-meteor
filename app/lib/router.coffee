Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  @route 'game',
    path: '/game/:_id'
    render: 'game'
    data: ->
      gameKey = @params._id
      players = TraitorPlayers.find(gameKey: gameKey, {sort: {order: 1}}).fetch()
      game: TraitorGames.findOne gameKey
      players: players
      me: _.find players, (player) -> player._id is Meteor.userId()