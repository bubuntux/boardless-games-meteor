gameKey = -> Session.get 'gameKey'
game = -> Session.get 'game'

setGame = (game) -> Session.set 'game', game

Template.game.onRendered ->
  Session.set 'gameKey', @data.gameKey #TODO move to router?

  stage = new createjs.Stage 'gameCanvas'
  createjs.Ticker.setFPS 60
  createjs.Ticker.addEventListener 'tick', stage
  createjs.Touch.enable(stage);

  TraitorGames.find(gameKey()).observe
    added: (game)-> setGame game
    changed: (newGame, oldGame) -> setGame newGame
    removed: (oldGame) -> setGame null

  TraitorPlayers.find(gameKey: gameKey(), {sort: {order: 1}}).observe
    addedAt: (player, index, before) ->
      circle = new createjs.Shape()
      circle.graphics.setStrokeStyle 2
      circle.graphics.beginStroke 'Blue'
      circle.graphics.beginFill 'DeepSkyBlue'
      circle.graphics.drawCircle 0, 0, 50

      text = new createjs.Text player.name, '20px Arial', 'White'
      text.y = 55

      container = new createjs.Container()
      container.name = player._id
      container.x = (index * 125) + 100
      container.y = 25
      container.alpha = 0
      container.addChild circle, text

      stage.addChild container

      createjs.Tween.get(container).to({alpha: 1, y: 75}, 1500, createjs.Ease.getBackInOut(5))
    removed: (player) ->
      createjs.Tween.get(stage.getChildByName(player._id))
      .to({alpha: 0, y: 25}, 1500, createjs.Ease.getBackInOut(5))
      .call(-> stage.removeChild(this))


  btnBackground = new createjs.Shape()
  btnBackground.graphics.beginFill('Red').drawRoundRect 0, 0, 150, 60, 10

  btnLabel = new createjs.Text "Hello World"
  btnLabel.x = 150 / 2
  btnLabel.y = 30

  btn = new createjs.Container()
  btn.x = 300
  btn.y = 200
  btn.addChild btnBackground, btnLabel

  btn.addEventListener "click", (event) ->
    Meteor.call 'joinGame', gameKey(), (error) -> throw error if error

  stage.addChild btn