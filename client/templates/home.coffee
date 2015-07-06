Template.home.events #TODO move logic to server
  'click .btn-create:not(.disabled)': (event, template) ->
    event.preventDefault()
    userId = Meteor.userId()
    if not userId
      throw new Meteor.Error 500, 'Not logged in'
    gameKey = template.$('[name=gameKey]').val()
    if not gameKey
      gameKey = Random.id 5 #TODO size in base of games
    if Games.find({_id: gameKey}, {limit: 1}).count() != 0
      throw new Meteor.Error 500, 'Game already created'
    Players.insert
      _id: userId
      name: Meteor.user().profile.name
    Games.insert
      _id: gameKey
      players: [userId]
    Router.go 'game', _id: gameKey

  'click .btn-join': (event, template) ->
    event.preventDefault()
    gameKey = template.$('[name=gameKey]').val()
    if not gameKey
      throw new Meteor.Error 500, 'Invalid game'
    Router.go 'game', _id: gameKey