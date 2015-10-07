Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  @route '/:gameName/:gameKey', ->
    board = Boards.findOne(gameName: @params.gameName, gameKey: @params.gameKey)
    @render 'join', data: ->
      board: board
  , name: 'join'
