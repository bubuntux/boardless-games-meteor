Template.the_resistance.helpers
  canVote: ->
    @game.state is ResistanceGameState.VICTORY or @game.state is ResistanceGameState.GAME_OVER or
      @game.state is ResistanceGameState.MISSION_VOTING or (@me.mission and @game.state is ResistanceGameState.ON_MISSION)
    #TODO: Exception in template helper: TypeError: Cannot read property 'mission' of undefined

  canStartMission: ->
    @me.leader and @game.state is ResistanceGameState.PLAYER_SELECTION

  showStartMissionBtn: ->
    playersOnMission = _.filter(@players, (player) -> player.mission).length
    playersOnMission is ResistanceConstants.PLAYERS_PER_ROUND[@players.length][@game.rounds.length]

  playersPerMissions: ->
    ResistanceConstants.PLAYERS_PER_ROUND[@players.length]

  playersPerMission: ->
    ResistanceConstants.PLAYERS_PER_ROUND[@players.length][@game.rounds.length]

  gameState: ->
    switch @game.state
      when ResistanceGameState.PLAYER_SELECTION then "Player Selection"
      when ResistanceGameState.MISSION_VOTING then "Mission voting"
      when ResistanceGameState.ON_MISSION then "On mission"
      when ResistanceGameState.VICTORY then "Victory"
      when ResistanceGameState.GAME_OVER then "Game Over"

  yesBtnClass: ->
    'active' if @me.secret_vote is true

  noBtnClass: ->
    'active' if @me.secret_vote is false

  identityLabel: ->
    if Session.get 'identity' then 'Hide identity' else 'Show identity'

Template.the_resistance.events
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