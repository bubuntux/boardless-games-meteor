#TODO collections 2

@Players = new Mongo.Collection 'players'

@Games = new Mongo.Collection 'games'
@Games.Player =
  min: 5
  max: 10
  divisor: 3 # Used for calculate number of traitor on the game
  perRound:
    5: [2, 3, 2, 3, 3]
    6: [2, 3, 4, 3, 4]
    7: [2, 3, 3, 4, 4]
    8: [3, 4, 4, 5, 5]
    9: [3, 4, 4, 5, 5]
    10: [3, 4, 4, 5, 5]
@Games.State =
  player_selection: 1
  mission_voting: 2
  mission: 3
  victory: 4
  game_over: 5
