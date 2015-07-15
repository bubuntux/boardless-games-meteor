Meteor.methods
  createGame: (gameKey) ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if not gameKey
      gameKey = Random.id 5 #TODO size in base of games
    if Games.find({_id: gameKey}, {limit: 1}).count() != 0
      throw new Meteor.Error 'Game already created'
    name = user.profile.name
    Players.upsert user._id, $set:
      name: if name then name else user.emails[0].address # TODO improve
      gameKey: gameKey
      gameMaster: true
    Games.insert
      _id: gameKey
      minPlayers: 5
      maxPlayers: 10
    gameKey

  joinGame: (gameKey) ->
    check gameKey, String
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    name = user.profile.name
    Players.upsert user._id, $set:
      name: if name then name else user.emails[0].address # TODO improve (refactor)
      gameKey: gameKey
