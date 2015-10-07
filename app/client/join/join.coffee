Template.join.helpers
  playerClass: ->
    board = Template.parentData().board
    'text-success' if board.players[0] is String(@)

  imGameMaster: ->
    @board.players[0] is Meteor.userId()

  btnStartClass: ->
    return if not @board?.players?
    'disabled' if @board.maxPlayers > @board.players.length or @board.players.length > @board.maxPlayers

  canJoin: ->
    return false if not @board?.players?
    if @board.players.length < @board.maxPlayers
      me = _.find(@board.players, (p) -> p is Meteor.userId())
      not me

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
