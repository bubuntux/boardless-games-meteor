@LoveLetters = new Mongo.Collection('love_letters')

@Guard =
  value: 1
  amount: 5
  name: "Guard"
  shortDesc: "Guess a player's hand"
  longDesc: "Name a non-Guard card and choose another player. If that player has that card he or she is out of the round"
  targetRequired: true

@Priest =
  value: 2
  amount: 2
  name: "Priest"
  shortDesc: "Look at a hand"
  longDesc: "Loog at another player's hand"
  targetRequired: true

@Baron =
  value: 3
  amount: 2
  name: "Baron"
  shortDesc: "Compare hands; lower hand is out"
  longDesc: "You and another player secretly compare hands. The player with the lower value is out of the round"
  targetRequired: true

@Handmaid =
  value: 4
  amount: 2
  name: "Handmaid"
  shortDesc: "Protection until your next turn"
  longDesc: "Until your next turn, ignore all effects from other player's cards"

@Prince =
  value: 5
  amount: 2
  name: "Prince"
  shortDesc: "One player discards his or her hand"
  longDesc: "Choose any player (including yourself) to discard his or her hand and draw a new card"
  validOnYourself: true

@King =
  value: 6
  amount: 1
  name: "King"
  shortDesc: "Trade hands"
  longDesc: "Trade hands with another player of your choice"
  targetRequired: true

@Countess =
  value: 7
  amount: 1
  name: "Countess"
  shortDesc: "Discard if caught with King or Prince"
  longDesc: "If you have this card and the King or Prince in your hand, you must discard this card"

@Princess =
  value: 8
  amount: 1
  name: "Princess"
  shortDesc: "Lose if discarded"
  longDesc: "If you discard this card, you are out of the round"

@LoveLettersCards = [Guard, Priest, Baron, Handmaid, Prince, King, Countess, Princess]

_allCards = ->
  cards = []
  for card in LoveLettersCards
    _.times(card.amount, -> cards.push(card.value))
  cards

@LoveLettersDescription =
  name: 'Love Letters'
  minPlayers: 2
  maxPlayers: 4
  initGame: (gameKey, players) ->
    remainCards = _.shuffle _allCards()
    discarded = remainCards.shift()
    order = 0
    for player in _.shuffle players
      player.order = order++
      player.cards = [remainCards.shift()]
      player.victories = 0
      player.protected = false
      player.see = undefined
    _.find(players, (p) -> p.order is 0).cards.push remainCards.shift()
    LoveLetters.upsert gameKey,
      $set:
        _id: gameKey
        players: players
        remainCards: remainCards
        discarded: discarded
        playedCards: []
  data: (gameKey) ->
    LoveLetters.findOne(gameKey)

Meteor.methods
  love_letters_play: (gameKey, card, otherPlayerId, guessCard) ->
    check card, Number if card
    check otherPlayerId, String if otherPlayerId
    check guessCard, Number if guessCard
    game = LoveLetters.findOne gameKey
    if not game
      throw new Meteor.Error "Invalid game"
    player = _.find game.players, (p) -> p.cards?.length is 2
    if not player
      throw  new Meteor.Error "WTF??" #TODO
    if player.id isnt Meteor.userId()
      throw new Meteor.Error "not your turn buddy"
    if not _.contains player.cards, card
      throw new Meteor.Error "you don't have that card dumb ass"

    cardObj = _.find(LoveLettersCards, (c) -> c.value is card)
    if cardObj.targetRequired or cardObj.validOnYourself
      otherPlayer = _.find game.players, (p)-> p.id is otherPlayerId
      if not otherPlayer
        throw new Meteor.Error "Invalid target"
      if otherPlayer.cards.length is 0
        throw new Meteor.Error "Invalid target, he already lost"
      if otherPlayer.id is player.id and not cardObj.validOnYourself
        throw new Meteor.Error "You can't play this card on yourself"

    if card is Guard.value and guessCard is Guard.value
      throw new Meteor.Error "Invalid guess Card"

    if _.contains player.cards, Countess.value and card isnt Countess.value
      if _.contains player.cards, King.value or _.contains player.cards, Prince.value
        throw new Meteor.Error "You MUST play the countess"

    player.cards = _.without player.cards, card
    player.cards = [card] if player.cards.length is 0
    player.protected = false
    _.each(game.players, (p)->
      p.see = undefined
      p.dontHave = undefined
    ) #TODO improve with unset?
    game.playedCards.push card

    switch card
      when Guard.value
        if not otherPlayer.protected and _.contains otherPlayer.cards, guessCard
          game.playedCards.push(otherPlayer.cards.pop())
        else
          otherPlayer.dontHave = LoveLettersCards[guessCard - 1].name
      when Priest.value
        if not otherPlayer.protected
          player.see = otherPlayer.id
      when Baron.value
        if not otherPlayer.protected
          if player.cards[0] > otherPlayer.cards[0]
            game.playedCards.push(otherPlayer.cards.pop())
          else if otherPlayer.cards[0] > player.cards[0]
            game.playedCards.push(player.cards.pop())
      when Handmaid.value
        player.protected = true
      when Prince.value
        if not otherPlayer.protected
          game.playedCards.push(otherPlayer.cards.pop())
          if game.remainCards.length > 0
            otherPlayer.cards = [game.remainCards.shift()]
      when King.value
        aux = player.cards
        player.cards = otherPlayer.cards
        otherPlayer.cards = aux
      when Princess.value
        game.playedCards.push(player.cards.pop())

    #TODO the game still?
    if game.remainCards.length > 0
      nextPlayer = _.find game.players, (p)-> p.order is player.order + 1
      nextPlayer = _.find(game.players, (p)-> p.order is 0) if not nextPlayer
      nextPlayer.cards.push game.remainCards.shift()
    else
#TODO
    delete game._id
    LoveLetters.update gameKey, $set: game