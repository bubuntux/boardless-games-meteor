Meteor.methods
  createGame: (gameName, gameKey) ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if not gameName
      throw new Meteor.Error "Unknown Game"
    if not gameKey
      gameKey = Random.id 3 #TODO size in base of games

    board = gameName: gameName, gameKey: gameKey, players: [user._id],
    minPlayers: 5, maxPlayers: 10 # TODO

    Boards.insert board, (error) -> throw error if error
    gameKey