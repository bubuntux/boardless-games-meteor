Template.game.onRendered ->
  stage = new createjs.Stage 'gameCanvas'
  createjs.Ticker.setFPS 60
  createjs.Ticker.addEventListener 'tick', stage
  createjs.Touch.enable(stage);

  TraitorPlayers.find(gameKey: @data.gameKey, {sort: {order: 1}}).observe
    addedAt: (player, index, before)->
      circle = new createjs.Shape()
      circle.graphics.beginFill('DeepSkyBlue').drawCircle 0, 0, 50

      text = new createjs.Text player.name, '20px Arial', 'White'
      text.y = 55

      playerContainer = new createjs.Container()
      playerContainer.x = (index * 125) + 100
      playerContainer.y = 25
      playerContainer.alpha = 0
      playerContainer.addChild circle, text

      stage.addChild playerContainer

      createjs.Tween.get(playerContainer).to({alpha: 1, y: 75}, 1500, createjs.Ease.getBackInOut(5))

  btnBackground = new createjs.Shape()
  btnBackground.graphics.beginFill('Red').drawRoundRect 0, 0, 150, 60, 10

  btnLabel = new createjs.Text "Hello World"
  btnLabel.x = 150 / 2
  btnLabel.y = 30

  btn = new createjs.Container()
  btn.x = 300
  btn.y = 200
  btn.addChild btnBackground, btnLabel

  btn.gameKey = @data.gameKey # improve?
  btn.addEventListener "click", (event) ->
    Meteor.call 'joinGame', event.target.parent.gameKey, (error) -> throw error if error

  stage.addChild btn