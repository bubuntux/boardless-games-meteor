Template.game.onRendered ->
  game = new Phaser.Game(640, 360, Phaser.AUTO, null, {preload, create, update, render})
  game.key = @data.gameKey

preload = ->
  @game.load.script('webfont', '//ajax.googleapis.com/ajax/libs/webfont/1.5.18/webfont.js');

create = ->
  game = @game
  TraitorPlayers.find(gameKey: game.key, {sort: {order: 1}}).observe
    addedAt: (player, index, before) ->
      group = game.add.group()
      group.x = (index * 125) + 100
      group.y = 25
      group.alpha = 0.0

      graphics = game.add.graphics(0, 0, group)
      graphics.lineStyle(3, 0x00ff00, 0.3)
      graphics.beginFill(0x3399cc, 0.8)
      graphics.drawCircle(25, 25, 50)
      graphics.endFill()

      text = game.add.text(0, 0, player.name, {font: "16px Droid Sans", fill: "#fff"}, group)
      text.x = (graphics.width - text.width) / 2
      text.y = graphics.height + 5

      game.add.tween(group).to({alpha: 1.0, y: 50}, 1000, Phaser.Easing.Bounce.Out, true)
    removed: (player) ->


update = ->


render = ->
