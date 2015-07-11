Meteor.methods
  createGame: (gameKey) ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if not gameKey
      gameKey = Random.id 5 #TODO size in base of games
    if Games.find({_id: gameKey}, {limit: 1}).count() != 0
      throw new Meteor.Error 'Game already created'
    Players.upsert user._id, $set:
      name: user.name
    Games.insert
      _id: gameKey
      players: [user._id]
    gameKey