Meteor.methods
  createGame: (gameKey) ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if not gameKey
      gameKey = Random.id 3 #TODO size in base of games
    if Games.find(_id: gameKey, {limit: 1}).count() != 0
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
    if Games.find(_id: gameKey, {limit: 1}).count() == 0
      throw new Meteor.Error 'Game not exist'
    name = user.profile.name
    Players.upsert user._id, $set:
      name: if name then name else user.emails[0].address # TODO improve (refactor)
      gameKey: gameKey

  startGame: -> # TODO elaborate
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    gameKey = Players.findOne(_id: user._id)?.gameKey
    if not gameKey
      throw new Meteor.Error "invalid player"
    Games.update _id: gameKey, $set:
      state: Games.State.player_selection
      rejected_missions: 0
      rounds: []
    , (error, n) ->
      if error
        throw error
      if n < 1 # TODO check
        throw new Meteor.Error "invalid game"
      if n > 1
        throw new Meteor.Error "invalid game."
    players = _.suffle Players.find(gameKey: gameKey).fetch()
    order = 0
    for player in players
      player.leader = order == 0
      player.order = order++
      player.traitor = false
      player.mission = false
      player.vote = false
      player.secret_vote = false
    for player in _.sample players, 2 #TODO
      player.traitor = true
    for player in players
      Players.upsert player._id, $set:
        order: player.order
        leader: player.leader
        traitor: player.traitor
        mission: player.mission
        vote: player.vote
        secret_vote: player.secret_vote
      gameKey