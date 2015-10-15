Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  @route '/:gameName/:gameKey', ->
    gameName = @params.gameName
    gameKey = @params.gameKey
    board = Boards.findOne({gameName, gameKey})
    if(board.started)
      @render gameName, data: ->
        GAME[gameName].data(gameKey)
    else
      @render 'join', data: ->
        board: board
  , name: 'join'
