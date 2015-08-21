class @PlayerContainer
  constructor: (stage) ->
    @main = new createjs.Container()
    @players = []
    stage.addChild(@main)

  addPlayer: (player) ->
    index = @players.length
    @players.push(player)

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

    y = if index < 5 then -15 else radius * 3 - 15
    container = new createjs.Container()
    container.name = player._id
    container.x = (if index < 5 then index else index - 5) * 150 + radius
    container.y = y
    container.alpha = 0
    container.addChild circle, text

    player.container = container

    @main.addChild container

    createjs.Tween.get(container).to({alpha: 1, y: y + 30}, 1000, createjs.Ease.getBackInOut(5))

  removePlayer: (oldPlayer) -> #clean up
    n = @players.length
    found = false
    i = 0
    while i < n
      player = @players[i]
      if found
        createjs.Tween.get(player.container)
        .to({x: (if i < 5 then i else i - 5) * 150 + 50}, 850, createjs.Ease.getBackInOut(2))
      else if player._id is oldPlayer._id
        found = true
        @players.splice(i, 1)
        n--
        i--
        createjs.Tween.get(player.container)
        .to({alpha: 0, y: player.container.y - 30}, 850, createjs.Ease.getBackInOut(5))
        .call(-> @parent.removeChild(@))
      i++

