Meteor.publish 'game', (gameKey) ->
  check gameKey, String
  gameCursor = TraitorGames.find gameKey, limit: 1
  game = gameCursor.fetch()[0]
  [
    gameCursor
    TraitorPlayers.find _id: {$in: game?.players}
  ]