Template.home.events #TODO move logic to server
  'click .btn-create:not(.disabled)': (event, template) ->
    event.preventDefault()
    gameKeyInput = template.$('[name=gameKey]').val()
    Meteor.call 'createGame', gameKeyInput, (error, gameKey) ->
      if error
        throw error
      Router.go 'game', _id: gameKey

  'click .btn-join': (event, template) ->
    event.preventDefault()
    gameKeyInput = template.$('[name=gameKey]').val()
    if not gameKeyInput #TODO should not be able to click
      throw new Meteor.Error 500, 'Invalid game'
    Router.go 'game', _id: gameKeyInput