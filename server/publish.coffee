Meteor.publish 'game', (gameKey) ->
  check gameKey, String
  [
    Games.find {_id: gameKey}, {limit: 1}
    Players.find gameKey: gameKey
  ]