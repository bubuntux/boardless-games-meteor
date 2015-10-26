@TheResistanceDescription =
  name: 'The Resistance'
  minPlayers: 5
  maxPlayers: 10

  initGame: (gameKey, players) ->
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
      ResistancePlayers.upsert player.id,
        $set:
          gameKey: gameKey
          order: player.order
          name : player.name
          leader: player.leader
          traitor: player.traitor
        $unset: # TODO check
          mission: false
          vote: false
          secret_vote: false

  data: (gameKey) ->
    players: ResistancePlayers.find(gameKey: gameKey).fetch()
    game: ResistanceGames.findOne gameKey