Meteor.methods
  joinGame: (gameName, gameKey) ->
    check gameName, String
    check gameKey, String
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    board = Boards.findOne({gameName, gameKey})
    if not board
      throw new Meteor.Error 'Game does not exist'
    if board.players.length >= board.maxPlayers
      throw new Meteor.Error 'Game already full'

    Boards.update {gameName, gameKey}, {$addToSet: {players: user._id}},
      (error) -> throw error if error