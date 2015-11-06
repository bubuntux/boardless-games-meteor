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

    name = user.username
    if not name
      email = _.first(user.emails).address
      name = email.substring(0, email.indexOf('@'))
    Boards.update {gameName, gameKey}, {$addToSet: {players: {id: user._id, name: name}}},
      (error) -> throw error if error