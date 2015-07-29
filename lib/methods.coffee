Meteor.methods
  vote: (vote, secret) ->
    check vote, Boolean
    user = Meteor.user()
    if not user
      throw new Meteor.Error "not-authorized"
    modifier = if secret then {
    $set:
      secret_vote: vote
    $unset:
      vote: true
    } else {
    $set:
      vote: vote
    $unset:
      secret_vote: true
    }
    Players.update _id: user._id, modifier, (error, n) ->
      if error
        throw error
      if n != 1 # TODO rollback??
        throw new Meteor.Error "invalid player"