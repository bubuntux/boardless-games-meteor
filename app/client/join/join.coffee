Template.join.helpers
  playerClass: ->
    board = Template.parentData().board
    'text-success' if board.players[0] is String(@)

  imGameMaster: ->
    return if not @board?.players
    @board.players[0] is Meteor.userId()

  btnStartClass: ->
    return if not @board?.players
    'disabled' if @board.minPlayers > @board.players.length or @board.players.length > @board.maxPlayers

  canJoin: ->
    user = Meteor.user()
    return false if not user or not @board?.players?
    if @board.players.length < @board.maxPlayers
      me = _.find(@board.players, (p) -> p is user._id)
      not me

Template.join.events
  'click .btn-join': (event) ->
    event.preventDefault()
    Meteor.call 'joinGame', @board.gameName, @board.gameKey, (error) -> throw error if error

  'click .btn-start': (event)->
    event.preventDefault()
    if event.target.classList.contains('disabled')
      currentClass = event.target.className
      event.target.className = currentClass?.replace('animated', 'animated shake')
    else
      Meteor.call 'startGame', (error) -> throw error if error #TODO animation

  'animationend': (event) ->
    event.target.classList.remove('fadeInDown')
    event.target.classList.remove('fadeInUp')
    event.target.classList.remove('shake')