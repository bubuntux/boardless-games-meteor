Meteor.methods
  createGame: (gameKey) ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if not gameKey
      gameKey = Random.id 3 #TODO size in base of games
    TraitorGames.insert _id: gameKey, (error) -> throw error if error
    TraitorPlayers.remove user._id
    TraitorPlayers.insert {
      _id: user._id
      gameMaster: true
      gameKey: gameKey
      name: user.profile.name or user.emails[0].address
    }
    gameKey

  joinGame: (gameKey) ->
    check gameKey, String
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    if TraitorGames.find(gameKey).count() is 0
      throw new Meteor.Error 'Game does not exist'
    players = TraitorPlayers.find(gameKey: gameKey).count()
    if players >= TraitorConstant.MAX_PLAYERS
      throw new Meteor.Error 'Game already full'
    TraitorPlayers.remove user._id
    TraitorPlayers.insert {
      _id: user._id
      gameKey: gameKey
      name: user.profile.name or user.emails[0].address
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
