###
# TODO  start game, description and so on...
gameKey = TraitorPlayers.findOne(_id: user._id)?.gameKey
if not gameKey
  throw new Meteor.Error "invalid player"

TraitorGames.update gameKey,
  $set:
    state: TraitorGameState.PLAYER_SELECTION
    distrust_level: 0
    rounds: []
, (error) -> throw error if error

players = _.shuffle TraitorPlayers.find(gameKey: gameKey).fetch()
order = 0
for player in players
  player.leader = order is 0
  player.order = order++
  player.traitor = false # TODO remove somehow?
for player in _.sample players, Math.ceil(players.length / TraitorConstant.TRAITOR_DIVISOR)
  player.traitor = true
for player in players
  TraitorPlayers.upsert player._id,
    $set:
      order: player.order
      leader: player.leader
      traitor: player.traitor
    $unset: # TODO check
      mission: true
      vote: true
      secret_vote: true
gameKey###
