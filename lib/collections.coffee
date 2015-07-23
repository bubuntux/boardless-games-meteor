#TODO collections 2

@Players = new Mongo.Collection 'players'

@Games = new Mongo.Collection 'games'
@Games.State =
  initial: 1
  player_selection: 2
  mission_voting: 3
  mission: 4
  victory: 5
  game_over: 6
