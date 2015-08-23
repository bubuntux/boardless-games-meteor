stage = null
gameKey = null

Template.game.onCreated ->
  gameKey = @data.gameKey

Template.game.onRendered ->
  stage = new createjs.Stage 'gameCanvas'
  playerContainer = new PlayerContainer()
  stage.addChild playerContainer.container

  TraitorPlayers.find(gameKey: gameKey, {sort: {order: 1}}).observe
    added: (player) -> playerContainer.addPlayer(player)
    removed: (player) -> playerContainer.removePlayer(player)

  joinButton()

  createjs.Touch.enable(stage);
  createjs.Ticker.setFPS 60
  createjs.Ticker.addEventListener 'tick', stage

joinButton = ->
  btnBackground = new createjs.Shape()
  btnBackground.graphics.beginFill('DeepSkyBlue').drawRoundRect 0, 0, 125, 30, 10

  btnLabel = new createjs.Text "Join", '20px Arial', 'White'
  bound = btnLabel.getBounds()
  btnLabel.x = (125 - bound.width) / 2
  btnLabel.y = (30 - bound.height) / 2

  btn = new createjs.Container()
  btn.x = (800 - 125) / 2
  btn.y = 450
  btn.addChild btnBackground, btnLabel

  btn.addEventListener "click", (event) ->
    Meteor.call 'joinGame', gameKey, (error) -> throw error if error

  stage.addChild btn