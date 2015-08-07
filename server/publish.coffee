Meteor.publish 'game', (gameKey) ->
  check gameKey, String
  [
    TraitorGames.find gameKey, limit: 1
    TraitorPlayers.find gameKey: gameKey
  ]