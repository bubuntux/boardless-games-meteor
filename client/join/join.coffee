Template.join.helpers
  playerClass: ->
    'text-success' if @gameMaster

  imGameMaster: ->
    @me?.gameMaster

  btnStartClass: ->
    'disabled' if TraitorConstant.MIN_PLAYERS > @players.length or @players.length > TraitorConstant.MAX_PLAYERS

  canJoin: ->
    @players.length < TraitorConstant.MAX_PLAYERS and not @me and Meteor.user()

Template.join.events
  'click .btn-join': (event) ->
    event.preventDefault()
    Meteor.call 'joinGame', @game._id, (error) -> throw error if error

  'click .btn-start': (event)->
    event.preventDefault()
    if event.target.classList.contains('disabled')
      currentClass = event.target.className
      event.target.className = currentClass?.replace('animated', 'animated shake')
    else
      #TODO animation
      Meteor.call 'startGame', (error) -> throw error if error
