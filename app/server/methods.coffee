Meteor.methods
  createGame: (gameName, gameKey) ->
    check gameName, String
    check gameKey, String
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if not gameName
      throw new Meteor.Error "Unknown Game"
    if not gameKey
      gameKey = Random.id 3 #TODO size in base of games

    board = gameName: gameName, gameKey: gameKey, players: [{id: user._id, name:user.username}],
    minPlayers: 5, maxPlayers: 10 # TODO according to the game

    Boards.insert board, (error) -> throw error if error
    gameKey

  startGame: (gameName, gameKey) ->
    check gameName, String
    check gameKey, String
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    board = Boards.findOne({gameName, gameKey})
    if not board
      throw new Meteor.Error "Unknown Game"


    Boards.update {gameName, gameKey}, {$set: {started: true}}

    # TODO according to the game
    gameKey = TraitorPlayers.findOne(_id: user._id)?.gameKey
    if not gameKey
      throw new Meteor.Error "invalid player"

    TraitorGames.update gameKey,
      $set:
        state: TraitorGameState.PLAYER_SELECTION
        distrust_level: 0
        rounds: []
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