Meteor.methods
  createGame: (gameKey) ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if not gameKey
      gameKey = Random.id 3 #TODO size in base of games
    TraitorGames.insert _id: gameKey, (error) -> throw error if error
    TraitorPlayers.remove user._id
    TraitorPlayers.insert
      _id: user._id
      gameMaster: true
      gameKey: gameKey
      name: user.profile.name or user.emails[0].address
    gameKey

  startGame: ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    gameKey = TraitorPlayers.findOne(_id: user._id)?.gameKey
    if not gameKey
      throw new Meteor.Error "invalid player"
    TraitorGames.update gameKey,
      $set:
        state: TraitorGameState.PLAYER_SELECTION
        rejected_missions: 0 #TODO unset?
        rounds: [] #TODO unset?
    , (error) -> throw error if error

    players = _.shuffle TraitorPlayers.find(gameKey: gameKey).fetch()
    order = 0
    for player in players
      player.leader = order is 0
      player.order = order++
      player.traitor = false # TODO remove somehow?
    for player in _.sample players, Math.ceil(players.length / TraitorConstant.TRAITOR_DIVISOR)
      player.traitor = true
    for player in players
      TraitorPlayers.upsert player._id,
        $set:
          order: player.order
          leader: player.leader
          traitor: player.traitor
        $unset: # TODO check
          mission: true
          vote: true
          secret_vote: true
    gameKey
