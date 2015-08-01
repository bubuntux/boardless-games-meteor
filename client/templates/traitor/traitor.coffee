Template.traitor.helpers
  canVote: ->
    (@game.state is Games.State.mission_voting) or (@me.mission and @game.state is Games.State.mission)

  canStartMission: ->
    playersOnMission = _.filter(@players, (player) -> player.mission).length
    playersOnMission is Games.Player.perRound[@players.length][@game.rounds.length]

  playersPerMission: ->
    Games.Player.perRound[@players.length][@game.rounds.length]

Template.traitor.events
  'click .btn-start-mission': (event) ->
    event.preventDefault()
    Meteor.call 'startMission'

  'click .btn-yes': (event) ->
    event.preventDefault()
    Meteor.call 'vote', true

  'click .btn-no': (event) ->
    event.preventDefault()
    Meteor.call 'vote', false