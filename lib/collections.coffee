#TODO collections 2
@TraitorPlayers = new Mongo.Collection 'traitorPlayers'

@TraitorGames = new Mongo.Collection 'traitorGames'
@TraitorConstant =
  MIN_PLAYERS: 5
  MAX_PLAYERS: 10
  MAX_FAILED_MISSIONS: 5
  TRAITOR_DIVISOR: 3
  PLAYERS_PER_ROUND:
    5: [2, 3, 2, 3, 3]
    6: [2, 3, 4, 3, 4]
    7: [2, 3, 3, 4, 4]
    8: [3, 4, 4, 5, 5]
    9: [3, 4, 4, 5, 5]
    10: [3, 4, 4, 5, 5]
@TraitorGameState =
  PLAYER_SELECTION: 1
  MISSION_VOTING: 2
  ON_MISSION: 3
  VICTORY: 4
  GAME_OVERr: 5