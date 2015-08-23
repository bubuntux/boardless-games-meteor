class @PlayerContainer
  constructor: ->
    @container = new createjs.Container()
    @players = []

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
    pContainer = new createjs.Container()
    pContainer.name = player._id
    pContainer.x = (if index < 5 then index else index - 5) * 150 + radius
    pContainer.y = y
    pContainer.alpha = 0
    pContainer.addChild circle, text

    player.container = pContainer

    @container.addChild pContainer

    createjs.Tween.get(pContainer).to({alpha: 1, y: y + 30}, 1000, createjs.Ease.getBackInOut(5))

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

class @ActionContainer
  constructor: (x, y, @width, @height) ->
    @container = new createjs.Container()
    @container.x = x
    @container.y = y

  update: ->
    btnBackground = new createjs.Shape()
    btnBackground.graphics.beginFill('DeepSkyBlue').drawRoundRect 0, 0, 125, 30, 10


  joinButton = ->
    btnBackground = new createjs.Shape()
    btnBackground.graphics.beginFill('DeepSkyBlue').drawRoundRect 0, 0, 125, 30, 10

    btnLabel = new createjs.Text "Join", '20px Arial', 'White'
    bound = btnLabel.getBounds()
    btnLabel.x = (125 - bound.width) / 2
    btnLabel.y = (30 - bound.height) / 2

    btn = new createjs.Container()
    btn.name = 'joinButton'
    btn.x = (800 - 125) / 2
    btn.y = 450
    btn.addChild btnBackground, btnLabel

    btn.addEventListener "click", (event) ->
      Meteor.call 'joinGame', gameKey, (error) -> throw error if error

    btn