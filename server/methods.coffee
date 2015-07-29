Meteor.methods
  createGame: (gameKey) ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if not gameKey
      gameKey = Random.id 3 #TODO size in base of games
    if Games.find(_id: gameKey, {limit: 1}).count() != 0
      throw new Meteor.Error 'Game already created'
    Games.insert _id: gameKey
    name = user.profile.name
    Players.upsert user._id, {
      $set:
        name: if name then name else user.emails[0].address # TODO improve
        gameKey: gameKey
        gameMaster: true
      $unset: #TODO unset everything but name and gamekey
        order: true
    }
    gameKey

  joinGame: (gameKey) ->
    check gameKey, String
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if Games.find(_id: gameKey, {limit: 1}).count() == 0
      throw new Meteor.Error 'Game not exist'
    #TODO still can join validation
    name = user.profile.name
    Players.upsert user._id, {
      $set:
        name: if name then name else user.emails[0].address # TODO improve (refactor)
        gameKey: gameKey
      $unset: #TODO unset everything but name and gamekey
        gameMaster: true
        order: true
    }

  startGame: ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    gameKey = Players.findOne(_id: user._id)?.gameKey
    if not gameKey
      throw new Meteor.Error "invalid player"
    Games.update {_id: gameKey}, $set:
      state: Games.State.player_selection
      rejected_missions: 0 #TODO unset?
      rounds: [] #TODO unset?
    , (error, n) ->
      if error
        throw error
      if n != 1 # TODO rollback??
        throw new Meteor.Error "invalid game"
    players = _.shuffle Players.find(gameKey: gameKey).fetch()
    order = 0
    for player in players
      player.leader = order == 0
      player.order = order++
      player.traitor = false # TODO remove somehow?
    for player in _.sample players, Math.ceil(players.length / Games.Player.divisor)
      player.traitor = true
    for player in players
      Players.upsert player._id, {
        $set:
          order: player.order
          leader: player.leader
          traitor: player.traitor
        $unset: # TODO check
          mission: true
          vote: true
          secret_vote: true
      }
    gameKey

  mission: (playerId)-> #xor not supported by minimongo :(
    check playerId, String
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    leader = Players.findOne _id: user._id, leader: true
    if not leader
      throw new Meteor.Error "You are not the leader"
    Players.update _id: playerId, {
      $bit:
        mission:
          xor: 1
    }, (error, n) ->
      if error
        throw error
      if n != 1
        throw new Meteor.Error "invalid player"