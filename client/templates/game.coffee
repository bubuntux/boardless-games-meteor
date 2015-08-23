stage = null
gameKey = null

Template.game.onCreated ->
  gameKey = @data.gameKey

Template.game.onRendered ->
  stage = new createjs.Stage 'gameCanvas'
  playerContainer = new PlayerContainer()
  actionContainer = new ActionContainer()

  stage.addChild playerContainer.container, actionContainer.container

  TraitorPlayers.find(gameKey: gameKey, {sort: {order: 1}}).observe
    added: (player) -> playerContainer.addPlayer(player)
    removed: (player) -> playerContainer.removePlayer(player)

  createjs.Touch.enable(stage);
  createjs.Ticker.setFPS 60
  createjs.Ticker.addEventListener 'tick', stage