Meteor.publish 'game', (gameKey) ->
  check gameKey, String
  #me = Players.findOne Meteor.userId TODO ?
  [
    Games.find {_id: gameKey}, {limit: 1}
    Players.find gameKey: gameKey
  ]