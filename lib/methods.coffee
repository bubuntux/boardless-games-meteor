Meteor.methods
  vote: (vote, secret) ->
    check vote, Boolean
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    modifier = if secret then {
    $set:
      secret_vote: vote
    $unset:
      vote: true
    } else {
    $set:
      vote: vote
    $unset:
      secret_vote: true
    }
    Players.update _id: user._id, modifier, (error, n) ->
      if error
        throw error
      if n != 1 # TODO rollback??
        throw new Meteor.Error "invalid player"

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
