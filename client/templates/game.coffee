stage = null
gameKey = null

Template.game.onCreated ->
  gameKey = @data.gameKey

Template.game.onRendered ->
  stage = new createjs.Stage 'gameCanvas'

  TraitorPlayers.find(gameKey: gameKey, {sort: {order: 1}}).observe
    addedAt: addPlayer
    removed: removePlayer

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
  btn.y = 200
  btn.addChild btnBackground, btnLabel

  btn.addEventListener "click", (event) ->
    Meteor.call 'joinGame', gameKey, (error) -> throw error if error

  stage.addChild btn

addPlayer = (player, atIndex) ->
  radius = 50
  circle = new createjs.Shape()
  circle.name = 'picture'
  circle.graphics.setStrokeStyle 3
  circle.graphics.beginStroke 'Blue'
  circle.graphics.beginFill 'DeepSkyBlue'
  circle.graphics.drawCircle radius, radius, radius

  text = new createjs.Text player.name, '20px Arial', 'White'
  text.name = 'name'
  text.x = text.getBounds().width / -2 + radius
  text.y = radius * 2

  y = if atIndex < 5 then -15 else radius * 3 - 15
  container = new createjs.Container()
  container.name = player._id
  container.x = (if atIndex < 5 then atIndex else atIndex - 5) * 150 + radius
  container.y = y
  container.alpha = 0
  container.addChild circle, text

  stage.addChild container

  createjs.Tween.get(container).to({alpha: 1, y: y + 15}, 1000, createjs.Ease.getBackInOut(5))

removePlayer = (oldPlayer) ->
  playerContainer = stage.getChildByName(oldPlayer._id)
  createjs.Tween.get(playerContainer)
  .to({alpha: 0, y: playerContainer.y - 30}, 850, createjs.Ease.getBackInOut(5))
  .call(-> stage.removeChild(this))