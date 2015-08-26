Template.game.helpers
  gameStarted: ->
    @game?.state?

Template.game.onRendered ->
  new WOW().init()