#TODO collections 2

@Players = new Mongo.Collection 'players'

@Games = new Mongo.Collection 'games'
@Games.Player =
  min: 4 #TODO check
  max: 10
  divisor: 3 # Used for calculate number of traitor on the game
@Games.State =
  player_selection: 1
  mission_voting: 2
  mission: 3
  victory: 4
  game_over: 5
