### Meteor.methods
  mission: (playerId)-> #xor not supported by minimongo :(
    check playerId, String
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    leader = Players.findOne _id: user._id, leader: true
    if not leader
      throw new Meteor.Error "You are not the leader"
    Players.update {_id: playerId, gameKey: leader.gameKey}, {
      $bit:
        mission:
          xor: 1
    }, (error, n) ->
      if error
        throw error
      if n != 1
        throw new Meteor.Error "invalid player"

  vote: (vote) ->
    check vote, Boolean
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    Players.update _id: user._id, {
      $set:
        secret_vote: vote
    }, (error, n) ->
      if error
        throw error
      if n != 1 # TODO rollback??
        throw new Meteor.Error "invalid player"
    player = Players.findOne _id: user._id
    players = Players.find({gameKey: player.gameKey}).fetch()
    if player.length isnt _.filter(players, (p) -> p.secret_vote?).length
      return
    game = Games.findOne _id: player.gameKey
    if game.state is Games.State.mission_voting
      if _.filter(players, (p) -> p.secret_vote).length > players.length / 2
        game.state = Games.State.mission
        game.rejected_missions = 0
      else
        game.rejected_missions++

      for player in players
        Players.update _id: player._id {
          $set:
            vote: player.secret_vote
          $unset:
            secret_vote: true
        }
    else if game.state is Games.State.mission
      true



  startMission: ->
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    leader = Players.findOne _id: user._id, leader: true
    if not leader
      throw new Meteor.Error "You are not the leader"
    game = Games.findOne _id: leader.gameKey
    if not game
      throw new Meteor.Error "Invalid game"
    players = Players.find(gameKey: leader.gameKey).fetch()
    playersOnMission = _.filter(players, (player) -> player.mission).length
    if playersOnMission isnt Games.Player.perRound[players.length][game.rounds.length]
      throw new Meteor.Error "Invalid number of players"
    Players.update gameKey: leader.gameKey, {
      $unset:
        vote: true
        secret_vote: true
    }
    Games.update _id: leader.gameKey, {
      $set:
        state: Games.State.mission_voting
    }, (error, n) ->
      if error
        throw error
      if n != 1 # TODO rollback??
        throw new Meteor.Error "invalid player"
###