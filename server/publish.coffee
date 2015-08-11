###
Meteor.publishComposite 'players', (gameKey) ->
  check gameKey, String
  collectionName: 'me'
  find: -> TraitorPlayers.find _id: @userId, gameKey: gameKey, {limit: 1}
  children:
    [
      find: (player) ->
        options = fields: {secret_vote: false}
        if not player.traitor
          options.fields.traitor = false
        TraitorPlayers.find gameKey: gameKey, options
    ]

Meteor.publish 'games', ->
  return TraitorGames.find {}###
