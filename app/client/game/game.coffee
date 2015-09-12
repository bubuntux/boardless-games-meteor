Template.game.helpers
  gameStarted: ->
    @game?.state?

Template.game.events
  'animationend': (event) ->
    #TODO improve
    event.target.classList.remove('fadeInDown')
    event.target.classList.remove('fadeInUp')
    event.target.classList.remove('shake')

###
'click .player': (event) ->
  currentClass = event.currentTarget.className
  event.currentTarget.className = currentClass?.replace('animated','animated fadeInDown')
###