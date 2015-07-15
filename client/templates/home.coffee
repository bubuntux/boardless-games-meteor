Template.home.helpers
  btnCreateClass: ->
    'disabled' if not Meteor.user()

Template.home.events
  'click .btn-create:not(.disabled)': (event, template) ->
    event.preventDefault()
    gameKeyInput = template.$('.gameKeyInput').val()
    Meteor.call 'createGame', gameKeyInput, (error, gameKey) ->
      if error
        throw error
      Router.go 'join', _id: gameKey

  'click .btn-join:not(.disabled)': (event, template) ->
    event.preventDefault()
    gameKeyInput = template.$('.gameKeyInput').val()
    if not gameKeyInput
      throw new Meteor.Error 500, 'Invalid game'
    Router.go 'join', _id: gameKeyInput

  'keyup .gameKeyInput': (event, template) ->
    event.preventDefault()
    if template.$('.gameKeyInput').val().length is 0
      template.$('.btn-join').addClass('disabled')
    else
      template.$('.btn-join').removeClass('disabled')
