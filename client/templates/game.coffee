Template.game.helpers
  gameStarted: ->
    @game?.state?

Template.game.events
  'animationend': (event) ->
    event.target.classList.remove('fadeInDown')

  'click .player': (event) ->
    currentClass = event.currentTarget.className
    event.currentTarget.className = currentClass?.replace('animated','animated fadeInDown')