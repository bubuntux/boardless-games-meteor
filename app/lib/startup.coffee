Meteor.startup ->
  if TraitorPlayers.find().count() is 0
    alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('')
    _.each alphabet, (letter) ->
      Accounts.createUser(
        username: letter
        email: letter + '@' + letter + '.com'
        password: '123123'
      )