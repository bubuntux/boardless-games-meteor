Meteor.publish 'game', (gameKey) ->
  check gameKey, String
  game = TraitorGames.findOne gameKey
  [
    TraitorGames.find gameKey, limit: 1
    TraitorPlayers.find _id: {$in: game.players}
  ]