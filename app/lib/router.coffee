Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  @route '/:gameName/:gameKey', ->
    board = Boards.findOne(gameName: @params.gameName, gameKey: @params.gameKey)
    if(board.started)
      return # TODO redirect to game
    else
      @render 'join', data: ->
        board: board
  , name: 'join'
