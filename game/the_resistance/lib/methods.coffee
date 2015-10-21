Meteor.methods
  mission: (playerId, mission)->
    check playerId, String
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    leader = ResistancePlayers.findOne _id: user._id, leader: true
    if not leader
      throw new Meteor.Error "You are not the leader"
    ResistancePlayers.update _id: playerId, gameKey: leader.gameKey,
      {$set: {mission: mission}},
      (error) -> throw error if error

  startMission: ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    gameKey = ResistancePlayers.findOne(_id: user._id, leader: true)?.gameKey
    if not gameKey
      throw new Meteor.Error "You are not the leader"
    game = ResistanceGames.findOne gameKey
    if not game
      throw new Meteor.Error "Invalid game"
    players = ResistancePlayers.find(gameKey: gameKey).fetch()
    playersOnMission = _.filter(players, (player) -> player.mission).length
    if playersOnMission isnt ResistanceConstants.PLAYERS_PER_ROUND[players.length][game.rounds.length]
      throw new Meteor.Error "Invalid number of players"
    ResistancePlayers.update gameKey: game._id,
      {$unset: {vote: true, secret_vote: true}},
      multi: true
    ResistanceGames.update gameKey,
      {$set: {state: ResistanceGameState.MISSION_VOTING}},
      (error) -> throw error if error

  vote: (vote) ->
    check vote, Boolean
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    ResistancePlayers.update _id: user._id,
      {$set: {secret_vote: vote}},
      (error) -> throw error if error
    gameKey = ResistancePlayers.findOne(user._id)?.gameKey
    if not gameKey
      throw new Meteor.Error "invalid game"
    players = ResistancePlayers.find(gameKey: gameKey).fetch()
    game = ResistanceGames.findOne gameKey
    delete game._id
    if game.state is ResistanceGameState.MISSION_VOTING
      if players.length isnt _.filter(players, (p) -> p.secret_vote?).length
        return
      unset = {secret_vote: true}
      if _.filter(players, (p) -> p.secret_vote).length > players.length / 2
        game.state = ResistanceGameState.ON_MISSION
        game.distrust_level = 0
      else
        game.state = ResistanceGameState.PLAYER_SELECTION
        game.distrust_level++
        unset.mission = true
        if game.distrust_level is ResistanceConstants.MAX_DISTRUST_LEVEL
          game.state = ResistanceGameState.GAME_OVER
        else
          currentLeader = _.find players, (player) -> player.leader
          nextLeader = _.find players, (player) -> player.order is currentLeader.order + 1
          if not nextLeader
            nextLeader = _.find players, (player) -> player.order is 0
          ResistancePlayers.update currentLeader._id, {$unset: {leader: true}}
          ResistancePlayers.update nextLeader._id, {$set: {leader: true}}

      for player in players
        ResistancePlayers.update player._id,
          {$set: {vote: player.secret_vote}, $unset: unset}
    else if game.state is ResistanceGameState.ON_MISSION
      playersPerRound = ResistanceConstants.PLAYERS_PER_ROUND[players.length][game.rounds.length]
      if playersPerRound isnt _.filter(players, (p) -> p.mission and p.secret_vote?).length
        return
      game.rounds.push _.filter(players, (p) -> p.mission and p.secret_vote is false).length
      count = _.countBy(game.rounds,
        (r) -> if (players.length < 7 and r is 0) or (players.length >= 7 and r < 2) then 'won' else 'lose')
      if count.won is ResistanceConstants.MISSIONS_TO_WIN
        game.state = ResistanceGameState.VICTORY
      else if game.lose is ResistanceConstants.MISSIONS_TO_WIN
        game.state = ResistanceGameState.GAME_OVER
      else
        game.state = ResistanceGameState.PLAYER_SELECTION
        currentLeader = _.find players, (player) -> player.leader
        nextLeader = _.find players, (player) -> player.order is currentLeader.order + 1
        if not nextLeader
          nextLeader = _.find players, (player) -> player.order is 0
        ResistancePlayers.update currentLeader._id, {$unset: {leader: true}}
        ResistancePlayers.update nextLeader._id, {$set: {leader: true}}
        for player in players
          ResistancePlayers.update player._id,
            {$unset: {vote: true, secret_vote: true, mission: true}}
    else if game.state is ResistanceGameState.GAME_OVER or game.state is ResistanceGameState.VICTORY
      ResistancePlayers.update user._id, {$set: {vote: vote}}
      if players.length is _.filter(players, (p) -> p.secret_vote?).length
        game.state = ResistanceGameState.PLAYER_SELECTION
        game.distrust_level = 0
        game.rounds = []

        players = _.shuffle players
        order = 0
        for player in players
          player.leader = order is 0
          player.order = order++
          player.traitor = false # TODO remove somehow?
        for player in _.sample players, Math.ceil(players.length / ResistanceConstants.TRAITOR_DIVISOR)
          player.traitor = true
        for player in players
          ResistancePlayers.upsert player._id,
            $set:
              order: player.order
              leader: player.leader
              traitor: player.traitor
            $unset: # TODO check
              mission: true
              vote: true
              secret_vote: true
    else
      return

    ResistanceGames.update gameKey, {$set: game}