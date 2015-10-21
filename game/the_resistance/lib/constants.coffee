@TheResistanceDescription =
  name: 'The Resistance'
  minPlayers: 5
  maxPlayers: 10
  initGame: (gameKey, players) ->
    # TODO  start game, description and so on...
    if not gameKey
      throw new Meteor.Error "invalid player"
    #Upsert this game
    ResistanceGames.upsert gameKey,
      $set:
        state: ResistanceGameState.PLAYER_SELECTION
        distrust_level: 0
        rounds: []
    , (error) -> throw error if error

    order = 0
    for player in players
      player.leader = order is 0
      player.order = order++
      player.traitor = false # TODO remove somehow?
    for player in _.sample players, Math.ceil(players.length / ResistanceConstants.TRAITOR_DIVISOR)
      player.traitor = true
    for player in players
      ResistancePlayers.upsert player._id,
        $set:
          order: player.order
          leader: player.leader
          traitor: player.traitor
        $unset: # TODO check
          mission: true
          vote: true
          secret_vote: true
    gameKey

  data: (gameKey) ->
    ResistanceGames.findOne(gameKey)

