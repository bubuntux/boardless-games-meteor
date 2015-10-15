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
      gameKey = Random.id 3 #TODO size in base of games or something...

    board = gameName: gameName, gameKey: gameKey, players: [{id: user._id, name: user.username}],
    minPlayers: GAME[gameName].minPlayers, maxPlayers: GAME[gameName].maxPlayers

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
    if board.players[0].id isnt user._id
      throw new Meteor.Error "Not leader"

    GAME[gameName].startGame(board.players)
    Boards.update {gameName, gameKey}, {$set: {started: true}}