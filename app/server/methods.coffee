Meteor.methods
  createGame: (name, key) ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if not name
      throw new Meteor.Error "Unknown Game"
    if not key
      key = Random.id 3 #TODO size in base of games

    board = name: name, key: key, users: [user.id]
    Boards.insert board, (error) -> throw error if error
    key