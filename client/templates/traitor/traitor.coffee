Template.traitor.helpers
  canVote: ->
    @game.state is TraitorGameState.VICTORY or @game.state is TraitorGameState.GAME_OVER or
      @game.state is TraitorGameState.MISSION_VOTING or (@me.mission and @game.state is TraitorGameState.ON_MISSION)

  canStartMission: ->
    @me.leader and @game.state is TraitorGameState.PLAYER_SELECTION

  showStartMissionBtn: ->
    playersOnMission = _.filter(@players, (player) -> player.mission).length
    playersOnMission is TraitorConstant.PLAYERS_PER_ROUND[@players.length][@game.rounds.length]

  playersPerMissions: ->
    TraitorConstant.PLAYERS_PER_ROUND[@players.length]

  playersPerMission: ->
    TraitorConstant.PLAYERS_PER_ROUND[@players.length][@game.rounds.length]

  gameState: ->
    switch @game.state
      when TraitorGameState.PLAYER_SELECTION then "Player Selection"
      when TraitorGameState.MISSION_VOTING then "Mission voting"
      when TraitorGameState.ON_MISSION then "On mission"
      when TraitorGameState.VICTORY then "Victory"
      when TraitorGameState.GAME_OVER then "Game Over"

  yesBtnClass: ->
    'active' if @me.secret_vote is true

  noBtnClass: ->
    'active' if @me.secret_vote is false

  identityLabel: ->
    if Session.get 'identity' then 'Hide identity' else 'Show identity'

Template.traitor.events
  'click .btn-start-mission': (event) ->
    event.preventDefault()
    Meteor.call 'startMission'

  'click .btn-vote': (event) ->
    event.preventDefault()
    vote = event.target.classList.contains 'btn-yes'
    Meteor.call 'vote', vote

  'click .btn-identity': (event) ->
    event.preventDefault()
    Session.set 'identity', not (Session.get 'identity')