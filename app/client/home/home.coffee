Template.home.helpers
  btnCreateClass: ->
    'disabled' if not Meteor.user()

Template.home.events
  'click .btn-create:not(.disabled)': (event, template) ->
    event.preventDefault()
    nameInput = template.$('.nameInput').val()
    keyInput = template.$('.keyInput').val()
    Meteor.call 'createGame', nameInput, keyInput, (error, key) ->
      if error
        throw error
      Router.go 'game', name: nameInput, key: key

  'click .btn-join:not(.disabled)': (event, template) ->
    event.preventDefault()
    gameKeyInput = template.$('.gameKeyInput').val()
    if not gameKeyInput
      throw new Meteor.Error 500, 'Invalid game'
    Router.go 'game', _id: gameKeyInput

  'keyup .gameKeyInput': (event, template) ->
    event.preventDefault()
    if template.$('.gameKeyInput').val().length is 0
      template.$('.btn-join').addClass('disabled')
    else
      template.$('.btn-join').removeClass('disabled')
